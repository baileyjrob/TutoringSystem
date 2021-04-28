class AddUserIdToCourseRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :course_requests, :user_id, :bigint
  end
end
