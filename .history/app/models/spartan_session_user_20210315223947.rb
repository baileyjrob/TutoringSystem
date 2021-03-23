# frozen_string_literal: true

# User-SpartanSession join table
class SpartanSessionUser < ApplicationRecord
  belongs_to :user
  belongs_to :spartan_session
  validates_presence_of :user_id, :spartan_session_id
end
