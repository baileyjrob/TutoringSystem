
# frozen_string_literal: true

# Courses-Users join table
class CourseUser < ApplicationRecord
belongs_to :course
belongs_to :user
validates :course_id, :user_id, presence: true
end
