class UpdateToFinalDraft < ActiveRecord::Migration[6.1]
  def change
    change_table :courses do |t|
      t.rename :subject_id, :department_id
    end
    change_table :departments do |t|
      t.rename :subject_name, :department_name
    end
    change_table :courses_users do |t|
      t.string :grade_achieved
    end
    change_table :spartan_sessions do |t|
      t.string :semester
    end

    change_table :spartan_sessions_users do |t|
      t.datetime :first_checkin
      t.datetime :second_checkin
    end
  end

    subject_ID -> department_ID
  end
end
