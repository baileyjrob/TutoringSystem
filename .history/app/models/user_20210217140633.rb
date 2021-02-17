class User < ApplicationRecord
  has_and_belongs_to_many :tutoring_sessions
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :roles
  validates :uin, presence: true
  include Encryptable
  #attr_encrypted :uin, :first_name, :last_name, :email Cannot encrypt numbers
  attr_encrypted :first_name, :last_name, :email
end
