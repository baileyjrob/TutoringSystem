class TutorController < ApplicationController
  def index
    @test = 'testing'
    @hello_message = 'hello!'
    @tutors = User.all
    @matchingTutors = @tutors.where(major: params[:filter_major])
    @noTutors = '<b> No Available Tutors </b>'.html_safe
    @availTutors = '<b> Available Tutors </b>'.html_safe
    @askRequest = ' Would you like to submit a request for a course? '.html_safe

    @submittedRequest = :requested_course
    # user = current_user
    # user.course_name << request
    @requestSuccessful = 'Request Recieved '.html_safe

    # TODO: use roles to filter tutors out
  end

  def fillRequests
    redirect_to 'tutor/index'
  end
end
