# frozen_string_literal: true

class CourseRequest < ApplicationRecord
  has_many :users, through: :role_users
end
