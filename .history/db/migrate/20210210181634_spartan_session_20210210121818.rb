class SpartanSession < ActiveRecord::Migration[6.1]
  def change
    create_table :spartan_sessions do |t|
      t.column :session_datetime, :datetime
    end
  end
end
