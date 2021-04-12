class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :course_requests, :course_name, :course_name_full
  end
  def up
    remove_column :course_requests, :request_id
  end
  
end