# frozen_string_literal: true

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
    @tutors = User.all
    # .roles.include?(Role.tutor_role)
    # @tutors = @tutors.include?(Role.tutor_role)
    # @matching_tutors = @tutors.where(include?(Role.tutor_role))
    @matching_tutors = @tutors.where(major: params[:filter_major])
    # would change tutors to matching tutors
    @no_tutors = '<b> No Available Tutors </b>'.html_safe
    @avail_tutors = '<b> Available Tutors </b>'.html_safe
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
      redirect_to '/course_request'
    else
      render :new
    end
  end

  def delete_all_request
    CourseRequest.delete_all
    redirect_to '/course_request', notice: 'Cleared all requests.'
  end

  private

  def course_request_params
    params.require(:course_request).permit(:course_name_full)
  end
end
