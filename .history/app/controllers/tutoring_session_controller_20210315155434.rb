# frozen_string_literal: true

# Controls the creation and tracking of tutoring sessions
class TutoringSessionController < ApplicationController
  before_action :authenticate_user!

  def index
    if cookies.key?('start_week')
      week_offset = 0
      start_week = Time.at(cookies['start_week'].to_f / 1000)

      if cookies.key?('week_offset')
        week_offset = cookies['week_offset'].to_f * 1.week
        cookies.delete 'week_offset'

        start_week += week_offset
        cookies['start_week'] = start_week.to_datetime.strftime('%Q')
      end

      start_week += 1.day # Offset by a day due to how time parses out when converted from cookie
    else
      start_week = Date.today.beginning_of_week(start_day = :sunday)
      cookies['start_week'] = start_week.to_datetime.strftime('%Q')
    end

    @week = {}

    # Get all sessions in the week (Might be not needed due to how rails parses queries)
    @tsessions = TutoringSession
                 .where('scheduled_datetime BETWEEN ? AND ?', start_week, start_week + 1.week)
                 .where('tutor_id = ?', current_user.id)

    # Get the sessions on every day and put them into a hash for frontend
    (0..6).each do |i|
      @week[i] = @tsessions
                 .where('scheduled_datetime BETWEEN ? AND ?', start_week + i.day, start_week + (i + 1).day)
                 .order('scheduled_datetime asc')
    end

    @start_of_week = start_week.to_date.to_formatted_s(:long_ordinal)
    @end_of_week = (start_week + 6.days).to_date.to_formatted_s(:long_ordinal)
  end

  def new; end

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
    @tsession = TutoringSession.new(tsession_params)

    @tsession.session_status = 'new'
    @tsession.tutor_id = current_user.id

    if @tsession.save
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
    @tsession.users.delete_all
    @tsession.delete # Destroy tries to delete all objects attatched to the session as well. Not good

    redirect_to tutoring_session_index_path, notice: 'Tutoring session deleted.'
  end

  private

  def tsession_params
    params.require(:tutoring_session).permit(:scheduled_datetime)
  end
end
