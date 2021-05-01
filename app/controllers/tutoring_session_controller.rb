# frozen_string_literal: true

require 'tutoring_session_controller_helper'
# Controls the creation and tracking of tutoring sessions
class TutoringSessionController < ApplicationController
  before_action :authenticate_user!
  before_action :check_tutor_role

  include TutoringSessionControllerHelper

  def generate_week(start_week)
    @week = {}

    # Get all sessions in the week (Might be not needed due to how rails parses queries)
    @tsessions = week_sessions(start_week)

    # Get the sessions on every day and put them into a hash for frontend
    increments = (0..6)
    dates = increments.to_a.map { |increment| start_week + increment.day }
    increments.each do |i|
      @week[dates[i]] = @tsessions
                        .where('scheduled_datetime BETWEEN ? AND ?',
                               start_week + i.day, start_week + (i + 1).day)
                        .order('scheduled_datetime asc')
    end
  end

  def index
    determine_start
    generate_week(@start_week)
    @start_of_week = week_to_string(@start_week)
    @end_of_week = week_to_string(@start_week + 6.days)
  end

  def new
    @tsession = TutoringSession.new
    redirect_to "/users/#{current_user.id}" unless current_user.tutor?
  end

  def edit
    @tsession = TutoringSession.find(params[:id])
    return if current_user.tutor? && current_user.sessions_tutoring.include?(@tsession)

    redirect_to "/users/#{current_user.id}"
  end

  def update
    @tsession = TutoringSession.find(params[:id])
    unless current_user.tutor? && current_user.sessions_tutoring.include?(@tsession)
      redirect_to "/users/#{current_user.id}" and return
    end

    if @tsession.update(tsession_params)
      redirect_to @tsession, notice: 'Tutoring session created.'
    else
      render 'edit'
    end
  end

  def create
    repeat = params[:repeat]
    create_setup
    if @tsession.save
      @tsession.generate_repeating_sessions_until_end_of_semester if repeat['session'].to_i == 1
      redirect_to tutoring_session_index_path, notice: 'Tutoring session created.'
    else
      render 'new'
    end
  end

  def show
    @tsession = TutoringSession.find(params[:id])
    return if tutor_session_admin_check

    redirect_to "/users/#{current_user.id}"
  end

  def destroy
    @tsession = TutoringSession.find(params[:id])
    redirect_to "/users/#{current_user.id}" and return unless tutor_session_admin_check

    @tsession.delete_repeating_sessions if params[:delete_repeating]

    @tsession.destroy

    redirect_to tutoring_session_index_path, notice: 'Tutoring session deleted.'
  end

  private

  def tsession_params
    params.require(:tutoring_session).permit(:scheduled_datetime, :completed_datetime, :session_status)
  end

  def determine_start
    # If the user has visited this before, get the cookie we put in
    if cookies.key?('start_week')
      @start_week = timezone_week_start
      @start_week = cookies.key?('week_offset') ? cookie_offset(@start_week) : @start_week + 1.day
    else
      @start_week = date_week_start
      cookies['start_week'] = @start_week.strftime('%Q')
    end
  end

  def tutor_session_admin_check
    prop_tutor = (current_user.tutor? && current_user.sessions_tutoring.include?(@tsession))
    prop_tutor || current_user.admin?
  end

  def create_setup
    @tsession = TutoringSession.new(tsession_params)

    @tsession.tutor_id = current_user.id

    local_time = Time.zone.local(params[:tutoring_session][:scheduled_datetime])
    params[:scheduled_datetime] = Time.zone.local_to_utc(local_time)
  end

  def check_tutor_role
    redirect_to "/users/#{current_user.id}" and return unless current_user.tutor?
  end
end
