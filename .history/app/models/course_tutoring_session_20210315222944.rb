# frozen_string_literal: true

# Courses-TutoringSessions join table
class CourseTutoringSession < ApplicationRecord
  belongs_to :course
  belongs_to :tutoring_session
end
