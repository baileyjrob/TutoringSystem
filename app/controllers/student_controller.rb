class StudentController < ApplicationController

  def index
    # TODO: Add necessary models here
  end

  def schedule
    # Get all tutoring sessions and users
    @sessions = TutoringSession.all
    @users = User.all
  end

  def schedule_session
    # TODO: Add user to tutor session in database
    # Use the join table to attach the user to the tutoring session
    user = User.find(params[:userID])
    session = TutoringSession.find(params[:sessionID])
    user.tutoringSession = session

    # Send us back to the student index page
    redirect_to '/student/index'
  end

  # Every method below here is temporary for the purpose of creating and deleting data to make everything function
  def create
    User.create(:uin => 1, :first_name => "John", :last_name => "Doe", :major => "MATH", :email => "john@doe.com")
    User.create(:uin => 2, :first_name => "Jane", :last_name => "Doe", :major => "MATH", :email => "jane@doe.com")
    User.create(:uin => 3, :first_name => "Jeff", :last_name => "Doe", :major => "MATH", :email => "jeff@doe.com")
    TutoringSession.create(:id => 1, :tutor_uin => 2, :scheduled_datetime => Time.now, :completed_datetime => nil, :session_status => "")
    TutoringSession.create(:id => 2, :tutor_uin => 3, :scheduled_datetime => Time.now, :completed_datetime => nil, :session_status => "")
  end

  def delete
    User.all.each do |user|
      user.destroy
    end
    TutoringSession.all.each do |session|
      session.delete
    end
  end

end
