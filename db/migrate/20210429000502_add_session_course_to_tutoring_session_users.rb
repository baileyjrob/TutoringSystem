class AddSessionCourseToTutoringSessionUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :tutoring_session_users, :session_course, :string
  end
end
