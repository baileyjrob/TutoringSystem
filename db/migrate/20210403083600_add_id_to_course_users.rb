class AddIdToCourseUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :course_users, :id, :primary_key
  end
end
