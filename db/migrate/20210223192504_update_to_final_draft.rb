# frozen_string_literal: true

class UpdateToFinalDraft < ActiveRecord::Migration[6.1]
  def change
    execute 'ALTER TABLE "users" DROP CONSTRAINT "users_pkey"'
    add_column :users, :id, :primary_key

    change_table :courses do |t|
      t.rename :subject_id, :department_id
      t.foreign_key :departments
    end
    change_table :departments do |t|
      t.rename :subject_name, :department_name
    end
    change_table :courses_users do |t|
      t.string :grade_achieved
      t.foreign_key :users
      t.foreign_key :courses
    end
    change_table :spartan_sessions do |t|
      t.string :semester
    end

    change_table :spartan_sessions_users do |t|
      t.datetime :first_checkin
      t.datetime :second_checkin
      t.foreign_key :users
      t.foreign_key :spartan_sessions
    end

    change_table :subjects_tutoring_sessions do |t|
      t.rename :subject_id, :department_id
      t.foreign_key :departments
      t.foreign_key :tutoring_sessions
    end

    rename_table :subjects_tutoring_sessions, :departments_tutoring_sessions

    change_table :tutoring_sessions do |t|
      t.remove :tutor_uin
      t.bigint :tutor_id
      t.string :semester
      t.foreign_key :users, column: :tutor_id
    end

    change_table :tutoring_sessions_users do |t|
      t.string :link_status
      t.text :student_notes
      t.foreign_key :tutoring_sessions
      t.foreign_key :users
    end

    change_table :roles_users do |t|
      t.foreign_key :roles
      t.foreign_key :users
    end

    change_table :courses_tutoring_sessions do |t|
      t.foreign_key :tutoring_sessions
      t.foreign_key :courses
    end
  end
end
