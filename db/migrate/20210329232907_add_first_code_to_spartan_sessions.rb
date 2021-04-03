class AddFirstCodeToSpartanSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :spartan_sessions, :first_code, :string
  end
end
