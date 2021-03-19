# frozen_string_literal: true

class RemoveUinFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :uin, :bigserial
  end
end
