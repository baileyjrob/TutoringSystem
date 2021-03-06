# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
User.create!(id: 0, first_name: 'Admin', last_name: 'User', email: "admin@tamu.edu", password: "T3st!!a")

User.create!(first_name: "John", last_name: "Doe", email: "john@tamu.edu", password: "T3st!!b")
user2 = User.create!(first_name: "Jane", last_name: "Doe", email: "jane@tamu.edu", password: "T3st!!c")
user3 = User.create!(first_name: "Jeff", last_name: "Doe", email: "jeff@tamu.edu", password: "T3st!!d")


user5 = User.create!(id: 15, first_name: 'Adam', last_name: 'Doe', major: 'CHEM', email: "adam@tamu.edu", password: "T3st!!e")
user6 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM', email: "ben@tamu.edu", password: "T3st!!f")
user7 = User.create!(id: 17, first_name: 'Christine', last_name: 'Doe', major: 'CHEM', email: "christine@tamu.edu", password: "T3st!!g")
user8 = User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH', email: "dakota@tamu.edu", password: "T3st!!h")
user9 = User.create!(id: 19, first_name: 'Ethan', last_name: 'Doe', major: 'MATH', email: "ethan@tamu.edu", password: "T3st!!i")


#role_id 1 is tutor, 2 is student, left 0 open for admin during testing purposes
role5 = Role.create!(id: 15, role_id: 1)
role6 = Role.create!(id: 16, role_id: 1)
role7 = Role.create!(id: 17, role_id: 2)
role8 = Role.create!(id: 18, role_id: 1)
role9 = Role.create!(id: 19, role_id: 2)

TutoringSession.create(id: 1, tutor_id: user2.id, scheduled_datetime: Time.now, completed_datetime: 0, session_status: "")
TutoringSession.create(id: 2, tutor_id: user3.id, scheduled_datetime: Time.now, completed_datetime: 0, session_status: "")
=end
admin_role = Role.create(role_name: 'Admin')
Role.create(role_name: 'Tutor')
Role.create(role_name: 'Student')
Role.create(role_name: 'Spartan Tutor')

admin = User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                email: 'admin@tamu.edu')

admin.roles << admin_role
