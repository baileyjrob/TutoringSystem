class TutorController < ApplicationController
    def index
        @test = "testing"
        @hello_message = "hello!"
        @tutors = User.all
        @matchingTutors = @tutors.where(major: params[:filter_major])
        @noTutors = "<b> No Available Tutors </b>".html_safe
        @askRequest = " Would you like to submit a request for a course? ".html_safe
        #TODO: use roles to filter tutors out 
    end

    def findTutors
        #@matchingTutors = tutors.where(major: params[:filter_major])
        
    end
        
end
