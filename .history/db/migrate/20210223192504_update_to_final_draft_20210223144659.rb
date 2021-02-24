class UpdateToFinalDraft < ActiveRecord::Migration[6.1]
  def change
    change_table :courses do |t|
      t.rename :subject_id, :department_id
    end
    create_table :departments do |t|
      t.rename :subject_name, :depatment_name
    end
  end

    subject_ID -> department_ID
  end
end
