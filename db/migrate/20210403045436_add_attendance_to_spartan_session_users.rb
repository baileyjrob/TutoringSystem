class AddAttendanceToSpartanSessionUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :spartan_session_users, :attendance, :string
  end
end
