class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.index :uin
      t.string :first_name
      t.string :last_name
      t.string :major
      t.string :email
    end
  end
end
