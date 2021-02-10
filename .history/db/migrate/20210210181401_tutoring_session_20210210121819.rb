class TutoringSession < ActiveRecord::Migration[6.1]
  def change
    create_table :tutoring_sessions do |t|
      t.column :tutor_uin, :integer
      t.column :scheduled_datetime, :datetime
      t.column :completed_datetime, :datetime
      t.column :session_status, :string
    end
  end
end
