# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    described_class.new(id: 0,
                        first_name: 'John',
                        last_name: 'Doe',
                        major: 'CSCE',
                        email: 'john@tamu.edu',
                        password: 'abcdef')
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'with a spartan email' do
      user.email = 'john@spartan-tutoring.com'
      expect(user).to be_valid
    end

    it 'without a major' do
      user.major = nil
      expect(user).to be_valid
    end
  end

  describe 'is not valid' do
    it 'without a first name' do
      user.first_name = nil
      expect(user).not_to be_valid
    end

    it 'without a last name' do
      user.last_name = nil
      expect(user).not_to be_valid
    end

    it 'without a password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'with a short password' do
      user.password = 'abc'
      expect(user).not_to be_valid
      user.password = 'abcdef'
    end

    it 'with a bad email' do
      user.email = 'something@something.com'
      expect(user).not_to be_valid
    end

    it 'without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'has default student role' do
      Role.create! role_name: 'Student'
      user = described_class.create!(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                                     email: 'asdf@tamu.edu', password: '12341234')
      user.reload
      user.roles.count.should eq(1)
    end

    it 'has default Spartan Tutor role' do
      Role.create! role_name: 'Spartan Tutor'
      user = described_class.create!(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                                     email: 'asdf@spartan-tutoring.com', password: '12341234')
      user.reload
      user.roles.count.should eq(1)
    end

    it 'returns false if not an admin' do
      expect(user).not_to be_admin
    end

    it 'returns true if a student' do
      Role.create! role_name: 'Student'
      user = described_class.create!(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                                     email: 'asdf@tamu.edu', password: '12341234')
      user.reload
      expect(user).to be_student
    end

    it 'returns true if a spartan tutor' do
      Role.create! role_name: 'Spartan Tutor'
      user = described_class.create!(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                                     email: 'asdf@spartan-tutoring.com', password: '12341234')
      user.reload
      expect(user).to be_spartan_tutor
    end

    it 'returns false if not a tutor' do
      Role.create! role_name: 'Student'
      user = described_class.create!(first_name: 'Andrew', last_name: 'last', major: 'CSCE',
                                     email: 'asdf@tamu.edu', password: '12341234')
      user.reload
      expect(user).not_to be_tutor
    end
  end

  describe 'database' do
    let(:user) do
      described_class.create(first_name: 'John',
                             last_name: 'Doe',
                             major: 'CSCE',
                             email: 'john@tamu.edu',
                             password: 'abcdef')
    end

    it 'deletes tutoring sessions it teaches' do
      Role.create(role_name: 'Tutor')
      user.roles << Role.find_by(role_name: 'Tutor')
      tutor_session = TutoringSession.create(scheduled_datetime: Time.zone.today.to_datetime,
                                             tutor_id: user.id)
      user.destroy
      expect(TutoringSession.exists?(tutor_session.id)).to be false
    end
  end
end
