class TutorController < ApplicationController
    def index
        @test = "testing"
        @hello_message = "hello!"
        @tutors = User.all
        #TODO: use roles to filter tutors out 
    end

    def findTutors
        @matchingTutors = @tutors.find(params[:filter_major])
        
    end
        
end
