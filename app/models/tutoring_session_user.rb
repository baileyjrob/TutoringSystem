# frozen_string_literal: true

# User-TutoringSessions join table
class TutoringSessionUser < ApplicationRecord
  STATUSES = %w[pending confirmed denied].freeze

  belongs_to :user
  belongs_to :tutoring_session
  validates :user_id, :tutoring_session_id, presence: true
  validates :link_status, inclusion: STATUSES
end
