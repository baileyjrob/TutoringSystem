class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.column :course_name, :string
      t.column :subject_id, :integer
    end
  end
end
