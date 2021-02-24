class UpdateToFinalDraft < ActiveRecord::Migration[6.1]
  def change
    change_table :courses do |t|
      t.rename :subject_id, :department_id
    end
    create_table :departments do |t|
      t.rename :subject_name, :depatment_name
    end
    create_table :courses_users do |t|
      t.string :grade_achieved
    end
  end

    subject_ID -> department_ID
  end
end
