class AddIdToSpartanSessionUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :spartan_session_users, :id, :primary_key
  end
end
