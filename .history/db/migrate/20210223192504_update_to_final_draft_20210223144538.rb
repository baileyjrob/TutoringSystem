class UpdateToFinalDraft < ActiveRecord::Migration[6.1]
  def change
    change_table :courses do |t|
      t.rename :subject_id, :department_id
    end
  end

    subject_ID -> department_ID
  end
end
