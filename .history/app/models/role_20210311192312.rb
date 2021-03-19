# frozen_string_literal: true

# Roles that a user can have/be
class Role < ApplicationRecord
  has_and_belongs_to_many :users
  validates_presence_of :role_name
end
