class CreateUsersCourseJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :courses
  end
end
