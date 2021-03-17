# frozen_string_literal: true

# Scheduled Tutoring Sessions
class TutoringSession < ApplicationRecord
  # has_and_belongs_to_many :courses
  has_many :course_tutoring_sessions, dependent: :delete_all
  has_many :courses, through: :course_tutoring_sessions
  # has_and_belongs_to_many :departments
  has_many :department_tutoring_sessions, dependent: :delete_all
  has_many :departments, through: :department_tutoring_sessions
  # has_and_belongs_to_many :users
  has_many :tutoring_session_users, dependent: :delete_all
  has_many :users, through: :tutoring_session_users

  validates :scheduled_datetime, presence: true

  validates_presence_of :scheduled_datetime
  validate :scheduled_datetime_has_no_overlap
  
  # Duration of all sessions set to 1 hour
  def duration_datetime
    scheduled_datetime + 1.hour
  end

  # Gets the offset based on the time, 0 is 0% and 24hr is 100%
  def top_offset
    "#{((scheduled_datetime.hour.to_f + (scheduled_datetime.min / 60.0)) / 24) * 100}%"
  end

  def end_of_semester_datetime
    ret = ('May 12th, ' + scheduled_datetime.year.to_s).to_datetime
    if scheduled_datetime > ret
      ret = ('December 17th, ' + scheduled_datetime.year.to_s).to_datetime
    end

    ret
  end

  def generate_repeating_sessions_until_end_of_semester
    repeat_scheduled_datetime = scheduled_datetime + 1.week
    repeat_end_date = end_of_semester_datetime
    
    while repeat_scheduled_datetime < repeat_end_date do
      rtsession = TutoringSession.new(scheduled_datetime: repeat_scheduled_datetime)

      rtsession.session_status = 'new'
      rtsession.tutor_id = tutor_id
      rtsession.save()

      repeat_scheduled_datetime += 1.week
    end
  end

  def delete_repeating_sessions
    repeat_scheduled_datetime = scheduled_datetime + 1.week
    repeat_end_date = end_of_semester_datetime
    repeating_scheduled_datetimes = []
    while repeat_scheduled_datetime < repeat_end_date do
      repeating_scheduled_datetimes << repeat_scheduled_datetime
      repeat_scheduled_datetime += 1.week

    end
    rtsessions = TutoringSession
                 .where(scheduled_datetime: repeating_scheduled_datetimes)
                 .where('tutor_id = ?', tutor_id)

    rtsessions.each do |rtsession|
      rtsession.users.delete_all
      rtsession.delete
    end
  end


  private
  
  def scheduled_datetime_has_no_overlap
    if scheduled_datetime == nil
      return
    end
    
    overlap = TutoringSession
                .where('scheduled_datetime BETWEEN ? AND ?', scheduled_datetime, duration_datetime)
                .where('tutor_id = ?', tutor_id)
    if overlap.exists?
      errors.add(:scheduled_datetime, "overlaps with one of yours that is currently scheduled")
    end
  end
end
