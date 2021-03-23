# frozen_string_literal: true

require 'tutoring_session_controller_helper'
# Controls the creation and tracking of tutoring sessions
class TutoringSessionController < ApplicationController
  before_action :authenticate_user!
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
    if cookies.key?('start_week')
      start_week = timezone_week_start
      start_week = cookie_offset(start_week) if cookies.key?('week_offset')
    else
      start_week = date_week_start
      cookies['start_week'] = start_week.strftime('%Q')
    end
    generate_week(start_week)
    @start_of_week = week_to_string(start_week)
    @end_of_week = week_to_string(start_week + 6.days)
  end

  def new
    @tsession = TutoringSession.new
  end

  def edit
    @tsession = TutoringSession.find(params[:id])
  end

  def update
    @tsession = TutoringSession.find(params[:id])

    if @tsession.update(tsession_params)
      redirect_to @tsession, notice: 'Tutoring session created.'
    else
      render 'edit'
    end
  end

  def create
    # Creates the new session, then adds the tutor to the session
    repeat = params[:repeat]
    @tsession = TutoringSession.new(tsession_params)

    @tsession.session_status = 'new'
    @tsession.tutor_id = current_user.id

    if @tsession.save
      @tsession.generate_repeating_sessions_until_end_of_semester if repeat['session'].to_i == 1

      redirect_to tutoring_session_index_path, notice: 'Tutoring session created.'

    else
      render 'new'
    end
  end

  def show
    @tsession = TutoringSession.find(params[:id])
  end

  def destroy
    @tsession = TutoringSession.find(params[:id])

    @tsession.delete_repeating_sessions if params[:delete_repeating]

    @tsession.users.delete_all
    @tsession.delete # Destroy deletes all objects attatched to the session as well. Not good

    redirect_to tutoring_session_index_path, notice: 'Tutoring session deleted.'
  end

  private

  def tsession_params
    params.require(:tutoring_session).permit(:scheduled_datetime)
  end
end
