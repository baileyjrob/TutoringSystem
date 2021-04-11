class AddOutfitInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mu, :string
    add_column :users, :outfit, :string
  end
end
