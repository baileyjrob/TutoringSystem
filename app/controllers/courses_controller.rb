class CoursesController < ApplicationController
  def new
  end

<<<<<<< Updated upstream
  def edit
  end

  def show
  end

  def index
=======
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def edit
  end

  def create
  end

  def delete
  end

  def destroy
>>>>>>> Stashed changes
  end
end
