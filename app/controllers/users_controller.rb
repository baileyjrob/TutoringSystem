# frozen_string_literal: true

# Primary management class for users
class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
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
    @user = User.find(params[:id])
    @tutoring_sessions = TutoringSession.all
  end

  def show_admin
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
    @sessions = TutoringSession.where('scheduled_datetime > :now', now: Time.zone.now.to_datetime)
                               .order(:scheduled_datetime)
  end

  def schedule_session_student
    user = User.find(params[:id])
    tutor_session = TutoringSession.find(params[:sessionID])

    tutor_session.users << user

    redirect_to "/users/#{params[:id]}"
  end

  def delete_session
    @user = User.find(current_user.id)
    @tutor_session = TutoringSession.find(params[:id])

    @user.tutoring_sessions.delete(@tutor_session)

    redirect_to show_schedule_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :major, :email, :encrypted_password,
                                 role_ids: [])
  end
end

# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
