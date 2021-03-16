# frozen_string_literal: true

# User-TutoringSessions join table
class TutoringSessionUser < ApplicationRecord
  belongs_to :user
  belongs_to :tutoring_session
  validates_presence_of :user_id, :tutoring_session_id
end
