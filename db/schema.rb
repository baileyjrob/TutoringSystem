# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_23_221214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.integer "department_id"
  end

  create_table "courses_tutoring_sessions", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "courses_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.string "grade_achieved"
  end

  create_table "departments", force: :cascade do |t|
    t.string "department_name"
  end

  create_table "departments_tutoring_sessions", id: false, force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_name"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "spartan_sessions", force: :cascade do |t|
    t.datetime "session_datetime"
    t.string "semester"
  end

  create_table "spartan_sessions_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spartan_session_id", null: false
    t.datetime "first_checkin"
    t.datetime "second_checkin"
  end

  create_table "tutoring_sessions", force: :cascade do |t|
    t.datetime "scheduled_datetime"
    t.datetime "completed_datetime"
    t.string "session_status"
<<<<<<< Updated upstream
=======
    t.datetime "session_date"
>>>>>>> Stashed changes
    t.bigint "tutor_id"
    t.string "semester"
  end

  create_table "tutoring_sessions_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tutoring_session_id", null: false
    t.string "link_status"
    t.text "student_notes"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "major"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "courses", "departments"
  add_foreign_key "courses_tutoring_sessions", "courses"
  add_foreign_key "courses_tutoring_sessions", "tutoring_sessions"
  add_foreign_key "courses_users", "courses"
  add_foreign_key "courses_users", "users"
  add_foreign_key "departments_tutoring_sessions", "departments"
  add_foreign_key "departments_tutoring_sessions", "tutoring_sessions"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "spartan_sessions_users", "spartan_sessions"
  add_foreign_key "spartan_sessions_users", "users"
  add_foreign_key "tutoring_sessions", "users", column: "tutor_id"
  add_foreign_key "tutoring_sessions_users", "tutoring_sessions"
  add_foreign_key "tutoring_sessions_users", "users"
end
