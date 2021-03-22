# frozen_string_literal: true

# Role-User join table
class RoleUser < ApplicationRecord
  belongs_to :role
  belongs_to :user
  validates :role_id, :user_id, presence: true
end
