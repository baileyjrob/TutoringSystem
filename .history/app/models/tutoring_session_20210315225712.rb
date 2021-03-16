# frozen_string_literal: true

# Scheduled Tutoring Sessions
class TutoringSession < ApplicationRecord
  #has_and_belongs_to_many :courses
  has_many :course_tutoring_sessions
  has_many :users, through: :course_tutoring_sessions
  #has_and_belongs_to_many :departments
  has_many :department_tutoring_sessions
  has_many :departments, through: :department_tutoring_sessions
  #has_and_belongs_to_many :users
  has_many :tutoring_session_users
  has_many :users, through: :tutoring_session_users

  validates :scheduled_datetime, presence: true

  # Duration of all sessions set to 1 hour
  def duration_datetime
    scheduled_datetime + 1.hour
  end

  # Gets the offset based on the time, 0 is 0% and 24hr is 100%
  def top_offset
    "#{((scheduled_datetime.hour.to_f + (scheduled_datetime.min / 60.0)) / 24) * 100}%"
  end
end
