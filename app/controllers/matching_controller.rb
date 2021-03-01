class MatchingController < ApplicationController
    
    def index
        #TODO: add necessary models here
    end
    
    #implement search function
    
    def people
        @tutors = User_Role.where(role_id: 2).all
        @students = User_Role.where(role_id: 1).all
    end

    def tutor_courses
        #TODO: find how to join tables and user_id + uin to link tutors with departments + courses
        
    end



    def create
        # Create some testing users and their roles
        User.create(:user_id => 11, :first_name => "Adam", :last_name => "Apple", :courses => "MATH", :email => "adam@apple.com")
        User.create(:user_id => 22, :first_name => "Barnie", :last_name => "Banana", :courses => "CHEM", :email => "barner@banana.com")
        User.create(:user_id => 33, :first_name => "Carol", :last_name => "Cranberry", :courses => "MATH", :email => "carol@cranberry.com")
        
        #role_id = student/tutor role, 1 is student, 2 is tutor
        User_Role.create(:uin => 101, :role_id => 1)
        User_Role.create(:uin => 202, :role_id => 1)
        User_Role.create(:uin => 303, :role_id => 2)
    end

    def delete
        User.find(11).destroy
        User.find(22).destroy
        User.find(33).destroy

        User_Role.find(101).delete
        User_Role.find(202).delete
        User_Role.find(303).delete
    end

end