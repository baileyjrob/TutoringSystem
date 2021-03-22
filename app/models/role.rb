# frozen_string_literal: true

# Roles that a user can have/be
class Role < ApplicationRecord
  has_and_belongs_to_many :users
  validates :role_name, presence: true

  def self.get_admin_role
    Role.where('role_name like ?', 'Admin').first
  end

  def to_s
    role_name
  end
end
