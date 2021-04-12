class CreateCourseRequestUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :course_request_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course_request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
