class Course < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :department
  has_and_belongs_to_many :tutoring_sessions
  validates :course_name, presence: true
  validates :department_id, presence: true
end
