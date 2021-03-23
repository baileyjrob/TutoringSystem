# frozen_string_literal: true

# Department-TutoringSessions join table
class DepartmentTutoringSession < ApplicationRecord
  belongs_to :department
  belongs_to :tutoring_session
  validates_presence_of :department_id, :tutoring_session_id
end
