# frozen_string_literal: true

class CreateSubjectsTutoringSessionsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :subjects, :tutoring_sessions
  end
end
