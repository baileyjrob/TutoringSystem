# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_role = Role.create(role_name: 'Admin');
Role.create(role_name: 'Tutor');
Role.create(role_name: 'Student');
Role.create(role_name: 'Spartan Tutor');

admin = User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                email: 'admin@tamu.edu')

admin.roles << admin_role
