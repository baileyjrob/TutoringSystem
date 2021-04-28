# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', :no_auth, type: :feature do
  before do
    # Create some data
    tutor_role = Role.create(role_name: 'Tutor')
    admin_role = Role.create(role_name: 'Admin')

    user1 = User.create!(id: 17, first_name: 'Christine', last_name: 'Doe', major: 'MATH',
                         email: 'christine@tamu.edu', password: 'T3st!!g')
    tutor1 = User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH',
                          email: 'dakota@tamu.edu', password: 'T3st!!h')
    tutor2 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM',
                          email: 'ben@tamu.edu', password: 'T3st!!f')

    TutoringSession.create(id: 1, tutor_id: tutor1.id, scheduled_datetime: Time.zone.now + 1.day,
                           completed_datetime: 0, session_status: '')
    TutoringSession.create(id: 2, tutor_id: tutor1.id, scheduled_datetime: Time.zone.now + 2.days,
                           completed_datetime: 0, session_status: '')
    TutoringSession.create(id: 3, tutor_id: tutor2.id, scheduled_datetime: Time.zone.now + 1.day,
                           completed_datetime: 0, session_status: '')
    math = Department.create(id: 1, department_name: 'MATH')
    chem = Department.create(id: 2, department_name: 'CHEM')
    math1 = Course.create(id: 1, department_id: math.id, course_name: '151')
    chem1 = Course.create(id: 3, department_id: chem.id, course_name: '117')

    user1.roles << admin_role
    tutor1.roles << tutor_role
    tutor2.roles << tutor_role
    tutor2.courses << chem1
    tutor2.courses << math1
    tutor1.courses << math1

    # Signing in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"

    # Join a session
    click_link 'Join Tutoring Session'
    click_button 'Join session', id: 1

    # go to tutor match by course page
    visit('/course_request')
    find(:link_or_button, 'Search by Specific Class').click
  end

  it 'visits tutor matching page' do
    expect(page).to have_content('Find a Tutor by Course')
  end

  # Dakota is a tutor, Christine is not, Christine should not be here
  describe 'Tutor match by course' do
    it 'can search by department and course number' do
      find('#department_id').find(:xpath, 'option[1]').select_option
      fill_in 'course_name', with: '151'
      find(:link_or_button, 'Find').click
      expect(page).to have_content('Dakota Doe')
    end

    it 'makes sure only tutors with a different major can pop up' do
      find('#department_id').find(:xpath, 'option[1]').select_option
      fill_in 'course_name', with: '151'
      find(:link_or_button, 'Find').click
      expect(page).to have_content('Ben Doe')
    end

    it 'makes sure only tutors can\'t show up in classes they don\'t tutor' do
      find('#department_id').find(:xpath, 'option[2]').select_option
      fill_in 'course_name', with: '117'
      find(:link_or_button, 'Find').click
      expect(page).not_to have_content('Dakota Doe')
    end
  end

  describe 'admin view of tutor matching' do
    it 'checks student tutor matches' do
      find(:link_or_button, 'Admin Pages').click
      find(:link_or_button, 'See Tutor Matches').click
      expect(page).to have_content('Dakota Doe')
    end
  end

  User.destroy_all
  TutoringSession.destroy_all
  Role.destroy_all
end
