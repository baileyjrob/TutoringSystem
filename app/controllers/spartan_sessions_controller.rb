# frozen_string_literal: true

class SpartanSessionsController < ApplicationController
  before_action :check_first_code, only: [:check_in_first]
  before_action :check_second_code, only: [:check_in_second]
  before_action :add_user_to_session, only: [:add_user]
  before_action :generate_csv, only: [:download]

  def index
    @sessions = SpartanSession.all.order(session_datetime: :asc)
  end

  def show
    @session = SpartanSession.find(params[:id])
    @users = @session.users
  end

  def edit_user
    @user = User.find(params[:userID])
    @suser = SpartanSessionUser.where(spartan_session_id: params[:id])
                               .and(SpartanSessionUser.where(user_id: params[:userID]))
                               .first
  end

  def update_attendance
    SpartanSessionUser.where(spartan_session_id: params[:id])
                      .and(SpartanSessionUser.where(user_id: params[:user_id]))
                      .first.update(attendance: params[:attendance_notes])

    redirect_to :spartan_session
  end

  def add_user
    SpartanSessionUser.where(spartan_session_id: params[:id])
                      .and(SpartanSessionUser.where(user_id: @id))
                      .first.update(attendance: params[:attendance_notes])

    redirect_to :spartan_session
  end

  def download
    csv = CSV.read("public/spartan_attendance_#{@time}.csv", headers: true)
    send_data csv, type: 'text/csv; charset=utf-8; header=present',
                   disposition: "attachment; filename=public/spartan_attendance_#{@time}.csv"
  end

  def check_in_first
    SpartanSessionUser.create(spartan_session_id: params[:sessionID],
                              user_id: current_user.id,
                              first_checkin: Time.zone.now)

    redirect_to "/users/#{current_user.id}"
  end

  def check_in_second
    session = SpartanSessionUser.where(spartan_session_id: params[:sessionID])
                                .and(SpartanSessionUser.where(user_id: current_user.id))
                                .first
    session.update(second_checkin: Time.zone.now)

    redirect_to "/users/#{current_user.id}"
  end

  private

  def generate_time(id)
    @time = SpartanSession.find(id).session_datetime.localtime.strftime('%Y%m%d_%H%M%S')
  end

  def generate_csv
    unless current_user.roles.include?(Role.admin_role)
      redirect_to root_path
      return
    end

    # include SpartanSessionExportHelper
    return unless request.post?

    # Pass in params to create the CSV
    generate_time(params[:id])
    SpartanSessionExportHelper.create_csv(params[:id], @time)
  end

  def add_user_to_session
    user = User.find_by(email: params[:email])

    if user.nil? || user.blank?
      redirect_to :spartan_session, alert: 'Invalid email input!'
    else
      session = SpartanSession.find(params[:id])

      # Only add the user if they don't exist already
      session.users << user unless session.users.exists?(user.id)

      # Need user.id to search in spartan session users table
      @id = user.id
    end
  end

  def check_first_code
    unless SpartanSession.find(params[:sessionID]).first_code ==
           params[:spartan_session_user][:code]
      flash.alert = 'Invalid check in code!'
      redirect_to "/users/#{current_user.id}"
    end
  end

  def check_second_code
    unless SpartanSession.find(params[:sessionID]).second_code ==
           params[:spartan_session_user][:code]
      flash.alert = 'Invalid check in code!'
      redirect_to "/users/#{current_user.id}"
    end
  end
end
