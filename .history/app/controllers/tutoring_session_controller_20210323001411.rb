# frozen_string_literal: true

# Controls the creation and tracking of tutoring sessions
class TutoringSessionController < ApplicationController
  before_action :authenticate_user!

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
      start_week = Time.zone.at(cookies['start_week'].to_f / 1000).beginning_of_day
      cookie_offset if cookies.key?('week_offset')
    else
      start_week = Date.today.beginning_of_week.to_datetime
      cookies['start_week'] = start_week.strftime('%Q')
    end
    generate_week(start_week)
    @start_of_week = start_week.to_date.to_formatted_s(:long_ordinal)
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

  def week_sessions(start_week)
    TutoringSession
      .where('scheduled_datetime BETWEEN ? AND ?', start_week, start_week + 1.week)
      .where('tutor_id = ?', current_user.id)
  end

  def cookie_offset
    week_offset = cookies['week_offset'].to_f * 1.week
    cookies.delete 'week_offset'

    start_week += week_offset
    cookies['start_week'] = start_week.to_datetime.strftime('%Q')
  end

  def week_to_string(week)
    week.to_date.to_formatted_s(:long_ordinal)
  end
end
