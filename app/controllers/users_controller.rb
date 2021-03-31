# frozen_string_literal: true

# Primary management class for users
class UsersController < ApplicationController
  before_action :authenticate_user!

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
    link = TutoringSessionUser.create(tutoring_session: tutor_session, user: user,
                                      link_status: 'pending')

    tutor_session.tutor.notifications.create(actor: user, action: 'student_application',
                                             notifiable: link)

    redirect_to "/users/#{params[:id]}"
  end

  def delete_session
    @user = User.find(current_user.id)
    @tutor_session = TutoringSession.find(params[:id])

    @user.tutoring_sessions.delete(@tutor_session)

    redirect_to show_schedule_path
  end

  # Temporary until emailing is a thing
  def admin_view_hours
    if !current_user.roles.include?(Role.admin_role)
      redirect_to root_path
      return
    end
    include TutoringSessionExportHelper
    if request.post?
      @start_date = params[:start_date] 
      @end_date = params[:end_date] 
      create_csv(start_date, end_date)
      @entries = CSV.read('public/tutoring_hours.csv', headers: true)
    end
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
