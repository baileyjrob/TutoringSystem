# frozen_string_literal: true

# Primary management class for users
class UsersController < ApplicationController
  # before_action :authenticate_user!
  def index
    @users = User.all
  end

  def show
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
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
    @sessions = TutoringSession.all
  end

  def schedule_session_student
    user = User.find(params[:id])
    tutor_session = TutoringSession.find(params[:sessionID])

    tutor_session.users << user

    redirect_to "/users/#{params[:id]}"
  end

  def delete_session
    user = User.find(current_user.id)
    tutor_session = TutoringSession.find(params[:sessionID])
    
    user.tutoring_sessions.delete(tutor_session)

    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :major, :email, :encrypted_password)
  end
end

# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
