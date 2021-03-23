class TutorController < ApplicationController
  def index
    @tutors = User.all
    @matching_Tutors = @tutors.where(major: params[:filter_major])
    @no_Tutors = '<b> No Available Tutors </b>'.html_safe
    @avail_Tutors = '<b> Available Tutors </b>'.html_safe
    @ask_Request = ' Would you like to submit a request for a course? '.html_safe

    @submitted_Request = :requested_course
    # user = current_user
    # user.course_name << request
    @request_Successful = 'Request Recieved '.html_safe

    # TODO: use roles to filter tutors out
  end
end
