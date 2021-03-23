class RenameJoinTables < ActiveRecord::Migration[6.1]
  def change
    rename_table :courses_tutoring_sessions, :course_tutoring_sessions
    rename_table :courses_users, :course_users
  end
end
