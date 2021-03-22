
# frozen_string_literal: true

# Scheduled Spartan Sessions
class SpartanSession < ApplicationRecord
# has_and_belongs_to_many :users
has_many :spartan_session_users, dependent: :delete_all
has_many :users, through: :spartan_session_users
validates :session_datetime, presence: true
end
