# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(id: 0, first_name: 'Admin', last_name: 'User', email: "admin@tamu.edu", password: "T3st!!a")
Role.create([{ role_name: 'Admin' }, { role_name: 'Tutor' }, { role_name: 'Student' }, { role_name: 'Spartan Tutor' }])
User.create!(first_name: "John", last_name: "Doe", email: "john@tamu.edu", password: "T3st!!b")
user2 = User.create!(first_name: "Jane", last_name: "Doe", email: "jane@tamu.edu", password: "T3st!!c")
user3 = User.create!(first_name: "Jeff", last_name: "Doe", email: "jeff@tamu.edu", password: "T3st!!d")

TutoringSession.create(id: 1, tutor_id: user2.id, scheduled_datetime: Time.now, completed_datetime: 0, session_status: "")
TutoringSession.create(id: 2, tutor_id: user3.id, scheduled_datetime: Time.now, completed_datetime: 0, session_status: "")
