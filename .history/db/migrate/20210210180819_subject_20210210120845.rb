class Subject < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.column :subject_name, :string
    end
  end
end
