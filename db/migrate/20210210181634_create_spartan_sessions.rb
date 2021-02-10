class CreateSpartanSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :spartan_sessions do |t|
      t.datetime :session_datetime
    end
  end
end
