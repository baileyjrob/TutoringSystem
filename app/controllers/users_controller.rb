# frozen_string_literal: true

require 'user_controller_helper'
require 'admin_view_hours_helper'
# Primary management class for users
class UsersController < ApplicationController
  include AdminViewHoursHelper
  include UserControllerHelper
  before_action :authenticate_user!

  def index
    bounce and return unless current_user.roles.include?(Role.admin_role)

    admin_index
  end

  def admin_index
    @users = User.all

    render 'admin_index'
  end

  def show
    # Get user and tutoring sessions
    @user = User.find(params[:id])
    # Permissions Check
    bounce_unless_ad_or_match(@user)

    @tutoring_sessions = TutoringSession.all

    # See if there is a spartan session to check into
    show_spart_sess
    @spartan_session_users = SpartanSessionUser.all
  end

  def show_admin
    bounce and return unless current_user.admin?

    @user = User.find(params[:id])
    @tutoring_sessions = TutoringSession.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    redirect_to @user and return if @user.save

    render :new
  end

  def edit
    redirect_to edit_user_registration_path and return unless current_user.admin?

    admin_edit
  end

  def admin_edit
    @user = User.find(params[:id])

    render 'admin_edit'
  end

  def update
    @user = User.find(params[:id])
    redirect_to @user and return if @user.update(user_params)

    edit
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  def show_schedule
    redirect_to new_user_session_path and return unless user_signed_in?

    @sessions = current_user.tutoring_sessions
  end

  def schedule_student
    @user = User.find(params[:id])
    bounce_unless_ad_or_match(@user)

    @sessions = TutoringSession.where('scheduled_datetime > :now', now: Time.zone.now.to_datetime)
                               .order(:scheduled_datetime)
  end

  def schedule_session_student
    user = User.find(params[:id])
    bounce and return unless user == current_user || current_user.admin?

    tutoring_session = TutoringSession.find(params[:sessionID])

    schedule_use_helpers(tutoring_session, user)

    redirect_to "/users/#{params[:id]}"
  end

  def delete_session
    @user = User.find(current_user.id)
    bounce_unless_ad_or_match(@user)

    @tutor_session = TutoringSession.find(params[:id])

    @user.tutoring_sessions.delete(@tutor_session)

    redirect_to show_schedule_path, notice: "Session Cancelled"
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
    params.require(:user).permit(:first_name, :last_name, :major, :mu,
                                 :outfit, :email, :encrypted_password,
                                 role_ids: [], course_ids: [])
  end

  def show_spart_sess
    @spartan_session = SpartanSession.where('session_datetime < :now',
                                            now: Time.zone.now.to_datetime)
                                     .and(SpartanSession.where('session_datetime > :startTime',
                                                               startTime: (Time.zone.now - 7200)
                                                                          .to_datetime))
  end

  def schedule_use_helpers(tutoring_session, user)
    helpers.pending_mail_with(tutoring_session.tutor, user).link_pending_email.deliver_now

    helpers.create_or_update_link_for(user, tutoring_session)
  end
end
