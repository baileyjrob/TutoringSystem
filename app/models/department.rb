# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :courses
  has_and_belongs_to_many :tutoring_sessions
  validates_presence_of :department_name
end
