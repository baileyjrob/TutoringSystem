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
  end

  def create
    @course = Course.new(params[:courses])
    if @course.save
      flash[:success] = 'course saved!'
    else
      flash[:alert] = 'course not saved!'
    end
  end

  def delete
  end

  def destroy
  end
end
