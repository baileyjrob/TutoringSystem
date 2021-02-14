class StudentController < ApplicationController

  def index
    # TODO: Add necessary models here
  end

  def schedule
    # TODO: See what needs to be added here
  end

  def schedule_session
    # TODO: Add tutor session to database

    redirect_to '/student/index'
  end

end
