# frozen_string_literal: true

require 'user_controller_helper'
class CourseRequestController < ApplicationController
  protect_from_forgery with: :null_session

  #   def index
  #     @tutors = User.all #include?(Role.tutor_role)
  #     @matching_tutors = @tutors.where(major: params[:filter_major])
  #     @no_tutors = '<b> No Available Tutors </b>'.html_safe
  #     @avail_tutors = '<b> Available Tutors </b>'.html_safe
  #     @course_requests = CourseRequest.all
  #     #redirect_to '/course_request/index'
  #   end
  #
  #
  #
  #   def new
  #     @crequest = CourseRequest.new
  #   end
  #
  #
  #   def create
  #     @course_requests = CourseRequest.all
  #     @ask_request = ' Would you like to submit a request for a course? '.html_safe
  #     @request_successful = 'Request Recieved '.html_safe
  #     #@crequest = CourseRequest.new
  #     @crequest = CourseRequest.new(params[:course_request_params])
  #     #@crequest.course_name_full = params[:requested_course]
  #     #@crequest = CourseRequest.new(course_name_full: "...")
  #     if @crequest.save
  #       #@submitted_request = params[:requested_course]
  #       #@crequest.user_id = current_user.id
  #       redirect_to @crequest, notice: 'Request successfully saved.'
  #
  #     else
  #       render 'new'
  #     end
  #   end
  #
  #   def show
  #     #@all_requests = CourseRequest.all
  #     @crequest = CourseRequest.find(params[:id])
  #   end
  #   private
  #     def course_request_params
  #       params.require(:course_request).permit(:course_name_full)
  #     end
  def index
    @course_requests = CourseRequest.all
    @tutor_count = -1
    @tutors = User.all
    @matching_tutors = @tutors.where(major: params[:filter_major]) # only accepts uppercase
    @tutor_count = 0 if params.key?(:filter_major)
    @matching_tutors.each do |user|
      @tutor_count = @tutor_count.to_i + 1 if user.tutor?
    end
    session_timeframe
  end

  def session_timeframe
    # set a two week range for what tutoring sessions students pull up
    @sessions = TutoringSession.where('scheduled_datetime > :now',
                                      now: Time.zone.now.to_datetime)
                               .order(:scheduled_datetime)
    @sessions = @sessions.where('scheduled_datetime < :two_weeks',
                                two_weeks: (Time.zone.now + 14.days).to_datetime)
                         .order(:scheduled_datetime)
  end

  def show
    @crequest = CourseRequest.find(params[:id])
  end

  def new
    @crequest = CourseRequest.new
  end

  def create
    @crequest = CourseRequest.new(course_request_params)

    if @crequest.save
      redirect_to '/course_request', notice: 'Request successfully saved.'
    else
      render :new
    end
  end

  def delete_all_request
    CourseRequest.delete_all
    redirect_to '/course_request', notice: 'Cleared all requests.'
  end

  # getting links for tutoring sessions, obtained from user_controller
  def schedule_session_student_cr
    user = current_user

    tutoring_session = TutoringSession.find(params[:sessionID])

    schedule_use_helpers(tutoring_session, user)

    redirect_to "/users/#{params[:id]}"
  end

  def schedule_use_helpers(tutoring_session, user)
    helpers.pending_mail_with(tutoring_session.tutor, user).link_pending_email.deliver_now

    helpers.create_or_update_link_for(user, tutoring_session)
  end

  private

  def course_request_params
    params.require(:course_request).permit(:course_name_full)
  end
end
