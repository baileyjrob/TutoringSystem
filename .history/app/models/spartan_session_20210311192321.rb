# frozen_string_literal: true

# Scheduled Spartan Sessions
class SpartanSession < ApplicationRecord
  has_and_belongs_to_many :users
  validates_presence_of :session_datetime
end
