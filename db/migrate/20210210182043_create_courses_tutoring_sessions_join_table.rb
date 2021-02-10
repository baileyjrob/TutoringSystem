class CreateCoursesTutoringSessionsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :courses, :tutoring_sessions
  end
end
