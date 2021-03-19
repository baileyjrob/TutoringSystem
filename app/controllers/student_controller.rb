# TODO: Make this a user controller to be more resourceful

class StudentController < ApplicationController
  def index
    # TODO: Add necessary models here
    @students = User.all
  end

  def schedule
    # Get all tutoring sessions and users
    @sessions = TutoringSession.all
    @users = User.all
  end

  def schedule_session
    # Use the join table to attach the user to the tutoring session
    user = User.find(params[:userID])
    session = TutoringSession.find(params[:sessionID])
    session.users << user

    # Send us back to the student index page
    redirect_to '/student/index'
  end
end
