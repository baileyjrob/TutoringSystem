# frozen_string_literal: true

class CreateUsersSpartanSessionsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :spartan_sessions
  end
end
