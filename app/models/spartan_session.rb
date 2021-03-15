# frozen_string_literal: true

# Scheduled Spartan Sessions
class SpartanSession < ApplicationRecord
  has_and_belongs_to_many :users
  validates :session_datetime, presence: true
end
