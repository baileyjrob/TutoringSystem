# frozen_string_literal: true

# Department that courses belong to (e.g. CSCE)
class Department < ApplicationRecord
  has_many :courses, dependent: :nullify
  # has_and_belongs_to_many :tutoring_sessions
  has_many :department_tutoring_sessions, dependent: :delete_all
  has_many :tutoring_sessions, through: :department_tutoring_sessions
  validates :department_name, presence: true
end
