# frozen_string_literal: true

# Department that courses belong to (e.g. CSCE)
class Department < ApplicationRecord
  has_many :courses
  has_and_belongs_to_many :tutoring_sessions
  validates :department_name, presence: true
end
