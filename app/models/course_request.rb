# frozen_string_literal: true

class CourseRequest < ApplicationRecord
  # has_and_belongs_to_many :users
  has_many :course_request_users, dependent: :delete_all
  has_many :users, through: :course_request_users
  validates :course_name_full, presence: true
end
