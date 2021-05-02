# frozen_string_literal: true

class TutorController < ApplicationController
  def index
    @tutors = User.all
    @matching_tutors = @tutors.where(major: params[:filter_major])
    @no_tutors = '<b> No Available Tutors </b>'.html_safe
    @avail_tutors = '<b> Available Tutors </b>'.html_safe
    @ask_request = ' Would you like to submit a request for a course? '.html_safe

    @submitted_request = :requested_course
    # user = current_user
    # user.course_name << request
    @request_successful = 'Request Recieved '.html_safe

    # TODO: use roles to filter tutors out
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    flash[:success] = 'course(s) saved!' if @user.update(user_params)
    redirect_to edit_tutor_path(@user.id)
  end

  def user_params
    params.require(:user).permit(course_ids: [])
  end

  def help
    render 'help'
  end

  def confirmed
    @confirmed_links = TutoringSessionUser.joins(:tutoring_session)
                                          .where(tutoring_session: { tutor_id: current_user.id })
                                          .where(link_status: 'confirmed')

    @in_person_sessions = TutoringSession.where(tutor_id: current_user.id)
                                         .where(session_status: 'In-Person')
  end

  def open
    @open_sessions = TutoringSession.where(tutor_id: current_user.id)
                                    .where(session_status: 'new')
                                    .or(TutoringSession.where(tutor_id: current_user.id)
                                      .where(session_status: 'denied'))
  end
end
