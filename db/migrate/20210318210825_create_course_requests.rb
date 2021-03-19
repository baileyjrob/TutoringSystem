class CreateCourseRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :course_requests do |t|
      t.string :course_name
    end
  end
end
