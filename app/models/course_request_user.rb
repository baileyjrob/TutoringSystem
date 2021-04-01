# frozen_string_literal: true

#CourseRequest - User join table
class CourseRequestUser < ApplicationRecord
  belongs_to :user
  belongs_to :course_request
  validates :user_id, :course_request_id, presence: true
end
