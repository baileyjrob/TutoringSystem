# frozen_string_literal: true

class CourseRequestController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @course_requests = CourseRequest.all
    @tutor_count = -1
    @tutors = User.all
    @matching_tutors = @tutors.where(major: params[:filter_major])
    @tutor_count = 0 if params.key?(:filter_major)
    @matching_tutors.each do |user|
      @tutor_count = @tutor_count.to_i + 1 if user.roles.include?(Role.tutor_role)
    end
    @no_tutors = '<b> No Available Tutors </b>'.html_safe
    
    @sessions = TutoringSession.where('scheduled_datetime > :now', now: Time.zone.now.to_datetime)
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

  private

  def course_request_params
    params.require(:course_request).permit(:course_name_full)
  end
end
