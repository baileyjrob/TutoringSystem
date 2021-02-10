class Course < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.column :course_name, :string
      t.column :subject_id, :string
    end
  end
end
