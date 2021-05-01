# frozen_string_literal: true

require 'user_controller_helper'
class CourseRequestController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @course_requests = CourseRequest.all
    @tutors = User.all
    if params.key?(:filter_major)
      @matching_tutors = @tutors.where(major: params[:filter_major].upcase)
    end
    session_timeframe
  end

  def tutor_match_by_course
    @tutors = User.all
    @courses = Course.all
    @course = @courses.where(department_id: params[:department_id])
    @course = @course.where(course_name: params[:course_name])
    session_timeframe
  end

  def session_timeframe
    # set a two week range for what tutoring sessions students can pull up
    @sessions = TutoringSession.where('scheduled_datetime > :now',
                                      now: Time.zone.now.to_datetime)
                               .order(:scheduled_datetime)
    @sessions = @sessions.where('scheduled_datetime < :two_weeks',
                                two_weeks: (Time.zone.now + 14.days).to_datetime)
                         .order(:scheduled_datetime)
  end

  def show
    @course_requests = CourseRequest.all
  end

  def new
    @crequest = CourseRequest.new
  end

  def create
    @crequest = CourseRequest.new(course_request_params)
    @crequest.user_id = current_user.id
    if @crequest.save
      redirect_to '/course_request', notice: 'Request successfully saved.'
    else
      render :new
    end
  end

  def delete_all_request
    CourseRequest.delete_all
    redirect_to '/course_request/admin_view_course_requests', notice: 'Cleared all requests.'
  end

  def admin_view_course_requests
    @course_requests = CourseRequest.all
  end

  def session_confirmation
    @selected_session = params[:sessionID]
  end

  # getting links for tutoring sessions, obtained and altered from user_controller
  def schedule_session_student_cr
    student = current_user
    return unless params[:sessionID].nil? == false # && (params[:session_course].nil? == false) rubocop thinks it's too much 

    tutoring_session = TutoringSession.find(params[:sessionID])
    schedule_use_helpers(tutoring_session, student, params[:session_course],
                         params[:student_notes])
    redirect_to "/users/#{params[:id]}", notice: 'Confirmed tutoring session'
  end

  def schedule_use_helpers(tutoring_session, user, session_course, student_notes)
    helpers.pending_mail_with(tutoring_session.tutor, user).link_pending_email.deliver_now

    helpers.create_or_update_link_for(user, tutoring_session, session_course, student_notes)
  end

  def admin_view_tutor_matches
    @students = User.all
  end

  private

  def course_request_params
    params.require(:course_request).permit(:course_name_full)
  end
end
