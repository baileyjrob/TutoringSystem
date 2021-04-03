# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  role = described_class.new(role_name: 'Admin')

  describe 'Validations' do
    it 'is valid with a name' do
      expect(role).to be_valid
    end

    it 'is not valid without a name' do
      role.role_name = nil
      expect(role).not_to be_valid
    end

    it 'returns true if user has admin role' do
      role = described_class.create!(role_name: 'Admin')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.admin_role).should be_truthy
    end

    it 'returns not nil if user has admin role' do
      role = described_class.create!(role_name: 'Admin')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.admin_role).not_to be_nil
    end

    it "nil if user doesn't have admin role" do
      role = described_class.create!(role_name: 'Student')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.admin_role).to be_nil
    end

    it 'returns true if user has student role' do
      role = described_class.create!(role_name: 'Student')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.student_role).should be_truthy
    end

    it 'returns not nil if user has student role' do
      role = described_class.create!(role_name: 'Student')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.student_role).not_to be_nil
    end

    it "nil if user doesn't have student role" do
      role = described_class.create!(role_name: 'Spartan Tutor')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@spartan-tutoring.com', password: '12341234')
      user.roles.push(role)
      expect(user.roles.student_role).to be_nil
    end

    it 'returns true if user has tutor role' do
      role = described_class.create!(role_name: 'Tutor')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.tutor_role).should be_truthy
    end

    it 'returns not nil if user has tutor role' do
      role = described_class.create!(role_name: 'Tutor')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.tutor_role).not_to be_nil
    end

    it "nil if user doesn't have tutor role" do
      role = described_class.create!(role_name: 'Spartan Tutor')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@spartan-tutoring.com', password: '12341234')
      user.roles.push(role)
      expect(user.roles.tutor_role).to be_nil
    end

    it 'returns true if user has spartan tutor role' do
      role = described_class.create!(role_name: 'Spartan Tutor')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@spartan-tutoring.com', password: '12341234')
      user.roles.push(role)
      expect(user.roles.spartan_tutor_role).should be_truthy
    end

    it 'returns not nil if user has spartan tutor role' do
      role = described_class.create!(role_name: 'Spartan Tutor')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@spartan-tutoring.com', password: '12341234')
      user.roles.push(role)
      expect(user.roles.spartan_tutor_role).not_to be_nil
    end

    it "nil if user doesn't have spartan tutor role" do
      role = described_class.create!(role_name: 'Student')
      user = User.create(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                         email: 'asdf@tamu.edu', password: '12341234')
      user.roles.push(role)
      expect(user.roles.spartan_tutor_role).to be_nil
    end
  end
end
