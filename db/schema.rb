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

ActiveRecord::Schema.define(version: 2021_02_12_182208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.integer "subject_id"
  end

  create_table "courses_tutoring_sessions", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "courses_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "subject_name"
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
  end

  create_table "spartan_sessions_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spartan_session_id", null: false
  end

  create_table "subjects_tutoring_sessions", id: false, force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "tutoring_sessions", force: :cascade do |t|
    t.integer "tutor_uin"
    t.datetime "scheduled_datetime"
    t.datetime "completed_datetime"
    t.string "session_status"
  end

  create_table "tutoring_sessions_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tutoring_session_id", null: false
  end

  create_table "users", primary_key: "uin", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "major"
    t.string "email"
  end

end
