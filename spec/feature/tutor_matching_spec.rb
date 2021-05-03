# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', :no_auth, type: :feature do
  before do
    # Create some data
    tutor_role = Role.create(role_name: 'Tutor')
    admin_role = Role.create(role_name: 'Admin')
    student_role = Role.create(role_name: 'Student')

    user1 = User.create!(id: 17, first_name: 'Christine', last_name: 'Doe', major: 'MATH',
                         email: 'christine@tamu.edu', password: 'T3st!!g')
    tutor1 = User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH',
                          email: 'dakota@tamu.edu', password: 'T3st!!h')
    tutor2 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM',
                          email: 'ben@tamu.edu', password: 'T3st!!f')

    TutoringSession.create(id: 1, tutor_id: tutor1.id, scheduled_datetime: Time.zone.now + 1.day,
                           completed_datetime: Time.zone.now + 1.day + 3600, session_status: '')
    TutoringSession.create(id: 2, tutor_id: tutor1.id, scheduled_datetime: Time.zone.now + 2.days,
                           completed_datetime: Time.zone.now + 2.days + 3600, session_status: '')
    TutoringSession.create(id: 3, tutor_id: tutor2.id, scheduled_datetime: Time.zone.now + 1.day,
                           completed_datetime: Time.zone.now + 1.day + 3600, session_status: '')
    TutoringSession.create(id: 4, tutor_id: user1.id, scheduled_datetime: Time.zone.now + 1.day,
                           completed_datetime: Time.zone.now + 1.day + 3600, session_status: '')
    TutoringSession.create(id: 5, tutor_id: tutor2.id, scheduled_datetime: Time.zone.now + 15.days,
                           completed_datetime: Time.zone.now + 15.days + 3600, session_status: '')
    user1.roles << admin_role
    user1.roles << student_role
    user1.roles << tutor_role
    tutor1.roles << tutor_role
    tutor2.roles << tutor_role

    # Signing in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click

    # Join a session
    find(:link_or_button, 'Find a Tutor').click
    fill_in 'filter_major', with: 'MATH'
    find(:link_or_button, 'Find').click
    click_button 'Join session', id: 1
    fill_in 'session_course', with: 'math 101'
    fill_in 'student_notes', with: 'derivatives'
    find(:link_or_button, 'Confirm').click
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
      find(:link_or_button, 'Find').click
      expect(page).to have_content('Dakota Doe')
    end
  end

  describe 'Display Tutor session information' do
    it 'doesn\'t show sessions held beyond two weeks later' do
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      # id for session in 15 days
      expect(page).not_to have_button 'Join session', id: 5
    end

    it 'doesn\'t show current user\'s sessions' do
      # id for user's own tutoring session
      expect(page).not_to have_button 'Join session', id: 4
    end

    it 'doesn\'t show joined sessions' do
      # id for user's joined session
      expect(page).not_to have_button 'Join session', id: 1
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

  describe 'admin view of tutor matching' do
    it 'checks student tutor matches' do
      find(:link_or_button, 'Admin Pages').click
      find(:link_or_button, 'See Tutor Matches').click
      expect(page).to have_content('Dakota Doe')
    end

    it 'checks tutor course' do
      find(:link_or_button, 'Admin Pages').click
      find(:link_or_button, 'See Tutor Matches').click
      expect(page).to have_content('math 101')
    end

    it 'checks student notes' do
      find(:link_or_button, 'Admin Pages').click
      find(:link_or_button, 'See Tutor Matches').click
      expect(page).to have_content('derivatives')
    end
  end

  User.destroy_all
  TutoringSession.destroy_all
  Role.destroy_all
end
