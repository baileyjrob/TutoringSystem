# frozen_string_literal: true

# Roles that a user can have/be
class Role < ApplicationRecord
  # has_and_belongs_to_many :users
  has_many :role_users, dependent: :delete_all
  has_many :users, through: :role_users
  validates :role_name, presence: true

  def self.admin_role
    Role.find_by('role_name like ?', 'Admin')
  end

  def self.student_role
    Role.find_by('role_name like ?', 'Student')
  end

  def self.tutor_role
    Role.find_by('role_name like ?', 'Tutor')
  end

  def self.spartan_tutor_role
    Role.find_by('role_name like ?', 'Spartan Tutor')
  end

  def to_s
    role_name
  end
end
