class User < ApplicationRecord
  has_and_belongs_to_many :tutoring_sessions
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :roles
  validates :uin, presence: true
end
