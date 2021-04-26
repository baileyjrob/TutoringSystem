# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', :no_auth, type: :feature do
  before do
    # Create some data
    tutor_role = Role.create(role_name: 'Tutor')
    student_role = Role.create(role_name: 'Student')
    admin_role = Role.create(role_name: 'Admin')

    user1 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM',
                         email: 'ben@tamu.edu', password: 'T3st!!f')
    user2 = User.create!(id: 17, first_name: 'Christine', last_name: 'Doe', major: 'MATH',
                         email: 'christine@tamu.edu', password: 'T3st!!g')
    tutor1 = User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH',
                          email: 'dakota@tamu.edu', password: 'T3st!!h')

    TutoringSession.create(id: 1, tutor_id: tutor1.id, scheduled_datetime: Time.zone.now + 1.day,
                           completed_datetime: 0, session_status: '')
    TutoringSession.create(id: 2, tutor_id: tutor1.id, scheduled_datetime: Time.zone.now + 2.days,
                           completed_datetime: 0, session_status: '')

    tutor1.roles << tutor_role
    user1.roles << admin_role
    user2.roles << student_role

    # Signing in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"

    # Join a session
    click_link 'Join Tutoring Session'
    click_button 'Join session', id: 1

    # go to tutor matching page
    visit('/course_request')
  end

  it 'visits tutor matching page' do
    expect(page).to have_content('Tutor Matching Page')
  end

  # Dakota is a tutor, Christine is not, Christine should not be here
  describe 'Available tutor matching' do
    it 'matches tutors using tutor majors' do
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      expect(page).to have_content('Dakota Doe')
    end
  end

  describe 'Display Tutor session information' do
    it 'shows sessions held by the tutors in the next two weeks' do
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      expect(page).to have_content('Scheduled Datetime')
    end
  end

  describe 'Non tutors do not show up' do
    it 'makes sure no students pop up in a tutor search' do
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      expect(page).not_to have_content('Christine Doe')
    end
  end

  # Make sure Ben doesn't show up
  describe 'No available tutor matching' do
    it 'tries to find a tutor' do
      fill_in 'filter_major', with: 'CHEM'
      find_button 'Find'
      click_button 'Find'
      expect(page).to have_content('No Available Tutors')
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
