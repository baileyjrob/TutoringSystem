# frozen_string_literal: true

class CreateUsersRolesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :roles
  end
end
