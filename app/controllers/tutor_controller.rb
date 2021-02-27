#temporary, just for hardcoded values to test tutor matching
def index
    @tutors = Users.all #where(role_id: 2 )
end

def find_tutor
    matchingTutor = @tutors.find(params[:major])
    
    #TODO
    #grabbing course id number to see if the tutor's taken it before
    
    redirect_to 'student/index'
end

