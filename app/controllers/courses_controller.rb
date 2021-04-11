# frozen_string_literal: true

class CoursesController < ApplicationController
  def new
    if !current_user.roles.include?(Role.admin_role) &&
       !current_user.roles.include?(Role.tutor_role)
      redirect_to "/users/#{current_user.id}"
    end
    @course = Courses.new
  end

  def edit
    if !current_user.roles.include?(Role.admin_role) &&
       !current_user.roles.include?(Role.tutor_role)
      redirect_to "/users/#{current_user.id}"
    end
  end

  def index
    @courses = Courses.all
  end

  def show
    @course = Courses.find(params[:id])
  end

  def create
    @course = Courses.new(course_params)
    if @course.save
      flash[:success] = 'course saved!'
    else
      flash[:alert] = 'course not saved!'
    end
  end
end
