# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(id: 0, first_name: 'Admin', last_name: 'User', email: "admin@tamu.edu", password: "T3st!!a")

User.create!(first_name: "John", last_name: "Doe", email: "john@tamu.edu", password: "T3st!!b")
user2 = User.create!(first_name: "Jane", last_name: "Doe", email: "jane@tamu.edu", password: "T3st!!c")
user3 = User.create!(first_name: "Jeff", last_name: "Doe", email: "jeff@tamu.edu", password: "T3st!!d")


user5 = User.create!(id: 15, first_name: 'Apple', last_name: 'Juice', major: 'CHEM', email: "apple@tamu.edu", password: "T3st!!e")
user6 = User.create!(id: 16, first_name: 'Orange', last_name: 'Juice', major: 'CHEM', email: "orange@tamu.edu", password: "T3st!!f")
user7 = User.create!(id: 17, first_name: 'Grape', last_name: 'Juice', major: 'CHEM', email: "grape@tamu.edu", password: "T3st!!g")
user8 = User.create!(id: 18, first_name: 'Lemon', last_name: 'Juice', major: 'MATH', email: "lemon@tamu.edu", password: "T3st!!h")
user9 = User.create!(id: 19, first_name: 'Pineapple', last_name: 'Juice', major: 'MATH', email: "pineapple@tamu.edu", password: "T3st!!i")

#role_id 1 is tutor, 2 is student, left 0 open for admin during testing purposes
role5 = Roles_user.create!(id: 15, role_id: 1)
role6 = Roles_user.create!(id: 16, role_id: 1)
role7 = Roles_user.create!(id: 17, role_id: 2)
role8 = Roles_user.create!(id: 18, role_id: 1)
role9 = Roles_user.create!(id: 19, role_id: 2)

