# frozen_string_literal: true

class TutorController < ApplicationController
  def index
    @submitted_request = "placeholder"
    @create_request = CourseRequest.new
    @current_request = @create_request
    @current_request.user_id = current_user.id
    @current_request.course_name_full = "testing".html_safe
    
    @request_successful = 'Request Recieved '.html_safe

    # TODO: use roles to filter tutors out
  end

  def matching_tutors
    @tutors = User.all
    @matching_tutors = @tutors.where(major: params[:filter_major])
    @no_tutors = '<b> No Available Tutors </b>'.html_safe
    @avail_tutors = '<b> Available Tutors </b>'.html_safe
    @ask_request = ' Would you like to submit a request for a course? '.html_safe
  
  end
  
 
end
