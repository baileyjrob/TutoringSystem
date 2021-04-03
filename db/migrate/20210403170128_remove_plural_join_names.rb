class RemovePluralJoinNames < ActiveRecord::Migration[6.1]
  def change
    drop_table :courses_tutoring_sessions
    drop_table :courses_users
    drop_table :departments_tutoring_sessions
    drop_table :roles_users
    drop_table :spartan_sessions_users
    drop_table :tutoring_sessions_users

  end
end
