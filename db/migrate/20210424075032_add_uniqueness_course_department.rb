class AddUniquenessCourseDepartment < ActiveRecord::Migration[6.1]
  def change
    add_index :departments, :department_name, unique: true
    add_index :courses, [:course_name, :department_id], unique: true
  end
end
