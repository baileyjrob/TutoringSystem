# frozen_string_literal: true

# Courses-TutoringSessions join table
class TutoringSessionUser < ApplicationRecord
  belongs_to :user
  belongs_to :tutoring_session
end
