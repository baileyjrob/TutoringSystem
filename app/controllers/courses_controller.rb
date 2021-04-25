# frozen_string_literal: true

class CoursesController < ApplicationController
  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
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
      redirect_to edit_tutor_path(current_user.id)
    else
      flash[:alert] = @course.errors
      redirect_to new_course_path
    end
  end

  def delete; end

  def destroy; end

  def course_params
    params.require(:course).permit(:course_name, :department_id)
  end
end
