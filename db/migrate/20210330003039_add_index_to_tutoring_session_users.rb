class AddIndexToTutoringSessionUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :tutoring_session_users, :id, :primary_key
  end
end
