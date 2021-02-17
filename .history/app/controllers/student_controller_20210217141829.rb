class BooksController < ApplicationController

    def edit
        @book = Book.find(params[:id])
    end

    def update
        @book = Book.find(params[:id])

        if @book.update(book_params)
            redirect_to root_path, notice: ("Book \"".concat(@book.title.concat("\" was updated")))
        else
            render :edit
        end
    end

    def destroy
        @book = Book.find(params[:id])
        if params[:confirm] == "1"
            @book.destroy
            redirect_to root_path, notice: ("Book \"".concat(@book.title.concat("\" was deleted")))
        end
    end

    private
        def book_params
            params.require(:book).permit(:title, :author, :genre, :price, :published_date)
        end
end

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

  def delete
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
