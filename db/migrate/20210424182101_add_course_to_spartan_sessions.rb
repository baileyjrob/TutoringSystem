class AddCourseToSpartanSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :spartan_sessions, :course, :string
  end
end
