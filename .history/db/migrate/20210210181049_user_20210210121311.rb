class User < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :major, :string
      t.column :email, :string
    end
  end
end
