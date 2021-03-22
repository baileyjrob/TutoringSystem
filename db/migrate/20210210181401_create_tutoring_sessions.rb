# frozen_string_literal: true

class CreateTutoringSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :tutoring_sessions do |t|
      t.integer :tutor_uin
      t.datetime :scheduled_datetime
      t.datetime :completed_datetime
      t.string :session_status
    end
  end
end
