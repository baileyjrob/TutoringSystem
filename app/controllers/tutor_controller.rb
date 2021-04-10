# frozen_string_literal: true

class TutorController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @tutors = User.all
    @matching_tutors = @tutors.where(major: params[:filter_major])
    @no_tutors = '<b> No Available Tutors </b>'.html_safe
    @avail_tutors = '<b> Available Tutors </b>'.html_safe
    @ask_request = ' Would you like to submit a request for a course? '.html_safe
    @request_successful = 'Request Recieved '.html_safe

    # TODO: use roles to filter tutors out
    @current_request = CourseRequest.new
    @all_requests = CourseRequest.all
  end

  def matching_tutors
    # eventually move tutor matching code here
  end

  def request_submission
    @all_requests = CourseRequest.all
    @ask_request = ' Would you like to submit a request for a course? '.html_safe
    @request_successful = 'Request Recieved '.html_safe
  end

  def new
    @current_request = CourseRequest.new
  end

  def create
    @current_request = CourseRequest.new(params[:course_request_params])
    @current_request = CourseRequest.create(params[:course_name_full])
    redirect_to '/tutor/request_submission', notice: 'Request submitted. Have a nice day!'

    # if @current_request.save
    # @submitted_request = params[:requested_course]

    # @current_request.user_id = current_user.id
    # @current_request.course_name_full = params[:requested_course]
    # redirect_to '/tutor/request_submission', notice: 'Request submitted. Have a nice day!'
    # end
  end

  def show
    @all_requests = CourseRequest.all
  end

  private

  def course_request_params
    params.require(:tutor).permit(:course_name_full)
  end
end
