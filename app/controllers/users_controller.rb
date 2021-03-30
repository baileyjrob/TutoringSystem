# frozen_string_literal: true

# Primary management class for users
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_first_code, only: [:check_in_first]
  before_action :check_second_code, only: [:check_in_second]

  def index
    if current_user.roles.include?(Role.admin_role)
      admin_index
      return
    end

    # Go to user home page
    redirect_to "/users/#{current_user.id}"
  end

  def admin_index
    @users = User.all

    render 'admin_index'
  end

  def show
    # Get user and tutoring sessions
    @user = User.find(params[:id])
    @tutoring_sessions = TutoringSession.all

    # See if there is a spartan session to check into
    @spartan_session = SpartanSession.where('session_datetime > :now',
                                            now: Time.zone.now.to_datetime)
                                     .and(SpartanSession.where('session_datetime < :endTime',
                                                               endTime: (Time.zone.now + 7200)
                                                                          .to_datetime))
                                     .first
    @spartan_session_users = SpartanSessionUser.all
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
    admin_edit
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
    @sessions = current_user.tutoring_sessions
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

  def check_in_first
    SpartanSessionUser.create(spartan_session_id: params[:sessionID],
                              user_id: current_user.id,
                              first_checkin: Time.zone.now)

    redirect_to "/users/#{current_user.id}"
  end

  def check_in_second
    ActiveRecord::Base.connection.execute('UPDATE "spartan_session_users"' \
                                            ' SET "second_checkin" =\'' + Time.zone.now.to_s +
                                            '\'' \
                                            'WHERE "user_id" = ' + current_user.id.to_s +
                                            ' AND "spartan_session_id" = ' + params[:sessionID].to_s)

    redirect_to "/users/#{current_user.id}"
  end

  def delete_session
    @user = User.find(current_user.id)
    @tutor_session = TutoringSession.find(params[:id])

    @user.tutoring_sessions.delete(@tutor_session)

    redirect_to show_schedule_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :major, :email, :encrypted_password)
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

# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
