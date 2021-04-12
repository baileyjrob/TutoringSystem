# frozen_string_literal: true

require 'user_controller_helper'
require 'admin_view_hours_helper'
# Primary management class for users
class UsersController < ApplicationController
  include AdminViewHoursHelper
  before_action :authenticate_user!

  def index
    if current_user.roles.include?(Role.admin_role)
      admin_index
    else
      redirect_to "/users/#{current_user.id}"
    end

    # TODO: Make view for non admins
  end

  def admin_index
    @users = User.all

    render 'admin_index'
  end

  def show
    # Get user and tutoring sessions
    @user = User.find(params[:id])
    # Permissions Check
    unless @user == current_user || current_user.admin?
      redirect_to "/users/#{current_user.id}"
      return
    end

    @tutoring_sessions = TutoringSession.all

    # See if there is a spartan session to check into
    @spartan_session = SpartanSession.where('session_datetime < :now',
                                            now: Time.zone.now.to_datetime)
                                     .and(SpartanSession.where('session_datetime > :startTime',
                                                               startTime: (Time.zone.now - 7200)
                                                                          .to_datetime))
                                     .first
    @spartan_session_users = SpartanSessionUser.all
  end

  def show_admin
    unless current_user.admin?
      redirect_to "/users/#{current_user.id}"
      return
    end
    @user = User.find(params[:id])
    @tutoring_sessions = TutoringSession.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    if current_user.roles.include?(Role.admin_role)
      admin_edit
      return
    end

    # TODO: Make view for non admins
    redirect_to edit_user_registration_path
  end

  def admin_edit
    @user = User.find(params[:id])

    render 'admin_edit'
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user
    else
      edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  def show_schedule
    if user_signed_in?
      @sessions = current_user.tutoring_sessions
    else
      redirect_to new_user_session_path
    end
  end

  def schedule_student
    @user = User.find(params[:id])
    unless @user == current_user || current_user.admin?
      redirect_to "/users/#{current_user.id}"
      return
    end
    @sessions = TutoringSession.where('scheduled_datetime > :now', now: Time.zone.now.to_datetime)
                               .order(:scheduled_datetime)
  end

  def schedule_session_student
    user = User.find(params[:id])
    unless user == current_user || current_user.admin?
      redirect_to "/users/#{current_user.id}"
      return
    end
    tutoring_session = TutoringSession.find(params[:sessionID])

    helpers.pending_mail_with(tutoring_session.tutor, user).link_pending_email.deliver_now

    helpers.create_or_update_link_for(user, tutoring_session)

    redirect_to "/users/#{params[:id]}"
  end

  def delete_session
    @user = User.find(current_user.id)
    unless @user == current_user || current_user.admin?
      redirect_to "/users/#{current_user.id}"
      return
    end
    @tutor_session = TutoringSession.find(params[:id])

    @user.tutoring_sessions.delete(@tutor_session)

    redirect_to show_schedule_path
  end

  def admin_view_hours
    admin_view_hours_prep
  end

  def output_admin_view_hours
    admin_view_hours_exec(params)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :major, :email, :encrypted_password,
                                 role_ids: [])
  end
end
