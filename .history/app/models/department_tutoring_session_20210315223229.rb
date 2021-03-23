# frozen_string_literal: true

# Department-TutoringSessions join table
class DepartmentTutoringSession < ApplicationRecord
  belongs_to :department
  belongs_to :tutoring_session
end
