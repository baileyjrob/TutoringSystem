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

  def edit_tutor_path
    @user = current_user
  end
end
