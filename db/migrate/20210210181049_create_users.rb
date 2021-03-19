class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: false do |t|
      t.primary_key :uin
      t.string :first_name
      t.string :last_name
      t.string :major
      t.string :email
    end
  end
end
