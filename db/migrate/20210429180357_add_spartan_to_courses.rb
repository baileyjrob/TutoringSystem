class AddSpartanToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :spartan, :boolean, :default => false
  end
end
