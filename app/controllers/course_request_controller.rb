#frozen_string_literal: true
class CourseRequestController < ApplicationController
  protect_from_forgery with: :null_session
  
  def index
    @tutors = User.all.include?(Role.tutor_role)
    @matching_tutors = @tutors.where(major: params[:filter_major])
    @no_tutors = '<b> No Available Tutors </b>'.html_safe
    @avail_tutors = '<b> Available Tutors </b>'.html_safe
    #redirect_to '/course_request/index'
  end

  def create
    @crequest = CourseRequest.new(params[:course_request_params])
    #@crequest = CourseRequest.create(params[:course_name_full])
    #@crequest.course_name_full = 'testing'
    if @crequest.save
      #@submitted_request = params[:requested_course]
      #@crequest.user_id = current_user.id
      redirect_to 'index', notice: 'Request successfully saved.'

    else
      render 'new'
    end
  end
    
  def new
    @crequest = CourseRequest.new
  end


  def requested
    @all_requests = CourseRequest.all
    @crequest = CourseRequest.new
    @ask_request = ' Would you like to submit a request for a course? '.html_safe
    @request_successful = 'Request Recieved '.html_safe
    @crequest = CourseRequest.new(params[:course_request_params])
    #@crequest.course_name_full = params[:requested_course]
    if @crequest.save
      #@submitted_request = params[:requested_course]
      #@crequest.user_id = current_user.id
      redirect_to 'index', notice: 'Request successfully saved.'

    else
      render 'new'
    end
  end

  def show
    @all_requests = CourseRequest.all
    #@crequest = CourseRequest.find(params[:id])
  end

  def delete_all_request
    CourseRequest.delete_all
    redirect_to 'index', notice: 'Cleared all requests.'
  end


  private
    def course_request_params
      params.require(:tutor).permit(:course_name_full)
    end
 

end
