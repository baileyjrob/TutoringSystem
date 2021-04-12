# frozen_string_literal: true

class CoursesController < ApplicationController
  def new
    @course = Course.new
  end

  def edit
    if !current_user.roles.include?(Role.admin_role) &&
       !current_user.roles.include?(Role.tutor_role)
      redirect_to "/users/#{current_user.id}"
    end
  end

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    @users = @course.users
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      flash[:success] = 'course saved!'
      redirect_to @course
    else
      flash[:alert] = 'course not saved!'
    end
  end

  def delete; end

  def destroy; end

  def my_courses; end

  def course_params
    params.require(:course).permit(:course_name, :department_id, user_ids: [])
  end
end
