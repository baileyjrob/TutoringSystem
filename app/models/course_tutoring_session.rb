
# frozen_string_literal: true

# Courses-TutoringSessions join table
class CourseTutoringSession < ApplicationRecord
belongs_to :course
belongs_to :tutoring_session
validates :course_id, :tutoring_session_id, presence: true
end
