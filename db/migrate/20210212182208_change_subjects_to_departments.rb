# frozen_string_literal: true

class ChangeSubjectsToDepartments < ActiveRecord::Migration[6.1]
  def change
    rename_table :subjects, :departments
  end
end
