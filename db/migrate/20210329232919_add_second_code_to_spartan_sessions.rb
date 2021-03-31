class AddSecondCodeToSpartanSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :spartan_sessions, :second_code, :string
  end
end
