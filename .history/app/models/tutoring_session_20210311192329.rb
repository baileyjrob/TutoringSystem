# frozen_string_literal: true

# Scheduled Tutoring Sessions
class TutoringSession < ApplicationRecord
  validates_presence_of :scheduled_datetime
  has_and_belongs_to_many :users
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :courses

  # Duration of all sessions set to 1 hour
  def duration_datetime
    scheduled_datetime + 1.hour
  end

  # Gets the offset based on the time, 0 is 0% and 24hr is 100%
  def top_offset
    "#{((scheduled_datetime.hour.to_f + (scheduled_datetime.min / 60.0)) / 24) * 100}%"
  end
end
