class StudentController < ApplicationController

  def index
    # TODO: Add necessary models here
  end

  def show
    # TODO: Display single model
  end

  def edit
    # TODO: Implement edit
  end

  def update
    # TODO: Implement update
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

    # TODO: Figure out how the join table works so that the user can be linked to the tutoring session
    session.users << user

    # Send us back to the student index page
    redirect_to '/student/index'
  end

  def new
    #TODO: Create object
  end

  # Every method below here is temporary for the purpose of creating and deleting data to make everything function
  def create
    # Create some users and tutoring sessions
    User.create(:uin => 1, :first_name => "John", :last_name => "Doe", :major => "MATH", :email => "john@doe.com")
    User.create(:uin => 2, :first_name => "Jane", :last_name => "Doe", :major => "MATH", :email => "jane@doe.com")
    User.create(:uin => 3, :first_name => "Jeff", :last_name => "Doe", :major => "MATH", :email => "jeff@doe.com")
    TutoringSession.create(:id => 1, :tutor_uin => 2, :scheduled_datetime => Time.now, :completed_datetime => nil, :session_status => "")
    TutoringSession.create(:id => 2, :tutor_uin => 3, :scheduled_datetime => Time.now, :completed_datetime => nil, :session_status => "")

    # Send us back to the student index page
    redirect_to '/student/index'
  end

  def destroy
    # Delete users and tutoring sessions from the create function
    User.find(1).destroy
    User.find(2).destroy
    User.find(3).destroy
    TutoringSession.find(1).delete
    TutoringSession.find(2).delete

    # Send us back to the student index page
    redirect_to '/student/index'
  end

end
