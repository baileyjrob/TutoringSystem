class CreateUsersTutoringSessionsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :tutoring_sessions
  end
end
