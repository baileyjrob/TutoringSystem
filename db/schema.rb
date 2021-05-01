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

ActiveRecord::Schema.define(version: 2021_04_29_180357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_request_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_request_id"], name: "index_course_request_users_on_course_request_id"
    t.index ["user_id"], name: "index_course_request_users_on_user_id"
  end

  create_table "course_requests", force: :cascade do |t|
    t.string "course_name_full"
    t.bigint "user_id"
  end

  create_table "course_tutoring_sessions", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "course_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.string "grade_achieved"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.integer "department_id"
    t.boolean "spartan", default: false
    t.index ["course_name", "department_id"], name: "index_courses_on_course_name_and_department_id", unique: true
  end

  create_table "department_tutoring_sessions", id: false, force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "department_name"
    t.index ["department_name"], name: "index_departments_on_department_name", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "role_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_name"
  end

  create_table "spartan_session_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spartan_session_id", null: false
    t.datetime "first_checkin"
    t.datetime "second_checkin"
    t.string "attendance"
  end

  create_table "spartan_sessions", force: :cascade do |t|
    t.datetime "session_datetime"
    t.string "semester"
    t.string "first_code"
    t.string "second_code"
    t.string "course"
  end

  create_table "tutoring_session_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tutoring_session_id", null: false
    t.string "link_status"
    t.text "student_notes"
    t.string "session_course"
  end

  create_table "tutoring_sessions", force: :cascade do |t|
    t.datetime "scheduled_datetime"
    t.datetime "completed_datetime"
    t.string "session_status"
    t.bigint "tutor_id"
    t.string "semester"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "unconfirmed_email"
    t.string "mu"
    t.string "outfit"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "course_request_users", "course_requests"
  add_foreign_key "course_request_users", "users"
  add_foreign_key "course_tutoring_sessions", "courses"
  add_foreign_key "course_tutoring_sessions", "tutoring_sessions"
  add_foreign_key "course_users", "courses"
  add_foreign_key "course_users", "users"
  add_foreign_key "courses", "departments"
  add_foreign_key "department_tutoring_sessions", "departments"
  add_foreign_key "department_tutoring_sessions", "tutoring_sessions"
  add_foreign_key "role_users", "roles"
  add_foreign_key "role_users", "users"
  add_foreign_key "spartan_session_users", "spartan_sessions"
  add_foreign_key "spartan_session_users", "users"
  add_foreign_key "tutoring_session_users", "tutoring_sessions"
  add_foreign_key "tutoring_session_users", "users"
  add_foreign_key "tutoring_sessions", "users", column: "tutor_id"
end
