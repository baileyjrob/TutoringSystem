# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins', :no_auth, type: :feature do
  before do
    # Create some data
    Role.create!([{ role_name: 'Admin' },
                  { role_name: 'Tutor' },
                  { role_name: 'Student' },
                  { role_name: 'Spartan Tutor' }])

    user1 = User.create!(first_name: 'John',
                         last_name: 'Doe',
                         email: 'john@tamu.edu',
                         password: 'T3st!!b')
    user1.roles << Role.find_by(role_name: 'Student')

    user2 = User.create!(first_name: 'Admin',
                         last_name: 'Doe',
                         email: 'admin@tamu.edu',
                         password: 'T3st!!b')
    user2.roles << Role.find_by(role_name: 'Admin')

    user3 = User.create!(first_name: 'Jimmy',
                         last_name: 'Doe',
                         email: 'jimmy@tamu.edu',
                         password: 'T3st!!b')
    user3.roles << Role.find_by(role_name: 'Student')

    SpartanSession.create(session_datetime: Time.zone.now + 6000,
                          first_code: 'asdasd',
                          second_code: '123123')

    session = SpartanSession.create(session_datetime: Time.zone.now - 6000,
                                    first_code: 'asdasd',
                                    second_code: '123123')

    SpartanSession.create(session_datetime: Time.zone.now - 8400,
                          first_code: 'asdasd',
                          second_code: '123123')

    # Will need to sign in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"

    # Check in
    fill_in 'Code', with: session.first_code
    click_button 'Check In'

    # Check out
    fill_in 'Code', with: session.second_code
    click_button 'Check Out'

    # Log out
    click_link 'Sign out'

    # Will need to sign in
    fill_in 'user_email', with: user2.email
    fill_in 'user_password', with: user2.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user2.id}"
  end

  after do
    SpartanSession.destroy_all
    User.destroy_all
  end

  it 'can access the spartan sessions list page' do
    click_link 'Admin Pages'
    find_link 'Spartan Session Index'
    click_link 'Spartan Session Index'
    expect(page).to have_content 'asdasd'
    find_button 'View Attendance', id: 1
  end

  it 'are the only ones who can download the csv file' do
    click_link 'Admin Pages'
    click_link 'Spartan Session Index'
    click_button 'View Attendance', id: 2
    User.find(2).roles << Role.find_by(role_name: 'Student')
    User.find(2).roles.delete(Role.find_by(role_name: 'Admin'))
    click_button 'Download'
    expect(page).to have_content 'Admin Doe'
  end

  describe 'can download an attendance report' do
    before do
      # Get to spartan session attendance viewing page
      click_link 'Admin Pages'
      click_link 'Spartan Session Index'
      click_button 'View Attendance', id: 2
    end

    it 'successfully' do
      click_button 'Download'
      expect(page).to have_content 'Time_In_Session'
    end
  end

  describe 'can view a session\'s attendance' do
    before do
      # Get to spartan session attendance viewing page
      click_link 'Admin Pages'
      click_link 'Spartan Session Index'
      click_button 'View Attendance', id: 2
    end

    it 'to see who has checked in and checked out' do
      # Make sure the button matches the user ID
      find_button 'Edit Notes', id: 1
      expect(page).to have_content 'Need to add someone?'
    end

    it 'and go back to the list page' do
      click_button 'Back'
      expect(page).to have_content 'asdasd'
    end

    it 'to see if no one has checked in' do
      click_button 'Back'
      click_button 'View Attendance', id: 1
      expect(page).to have_content 'No one has attended this session.'
    end

    it 'to add a user to the attendance list' do
      fill_in 'email', with: 'jimmy@tamu.edu'
      fill_in 'attendance_notes', with: 'TEST'
      click_button 'Add User'
      expect(page).to have_content 'TEST'
    end

    it 'to update a user in the attendance list' do
      fill_in 'email', with: 'john@tamu.edu'
      fill_in 'attendance_notes', with: 'TEST'
      click_button 'Add User'
      expect(page).to have_content 'TEST'
    end

    it 'and prevent bad user\'s from being added' do
      fill_in 'email', with: 'aasdsd'
      fill_in 'attendance_notes', with: 'TEST'
      click_button 'Add User'
      expect(page).not_to have_content 'TEST'
    end

    it 'to get to the page to update a user\'s attendance status' do
      click_button 'Edit Notes', id: 1
      find_button 'Update attendance'
    end
  end

  describe 'can edit a user\'s attendance status' do
    before do
      # Get to spartan session attendance viewing page
      click_link 'Admin Pages'
      click_link 'Spartan Session Index'
      click_button 'View Attendance', id: 2

      # Go to user's update page
      click_button 'Edit Notes', id: 1
    end

    it 'and cancel if needed' do
      click_button 'Back'
      expect(page).to have_content 'Need to add someone?'
    end

    it 'and make sure it saved' do
      fill_in 'attendance_notes', with: 'TEST'
      click_button 'Update attendance'
      expect(page).to have_content 'TEST'
      find_button 'Edit Notes'
    end
  end

  describe 'can see the current attendance status' do
    before do
      # Get to spartan session attendance viewing page
      click_link 'Admin Pages'
      click_link 'Spartan Session Index'
      click_button 'View Attendance', id: 2

      # Add user with custom attendance status
      fill_in 'email', with: 'jimmy@tamu.edu'
      fill_in 'attendance_notes', with: 'TEST'
      click_button 'Add User'

      # Go to user's update page
      click_button 'Edit Notes', id: 3
    end

    it 'when editing it' do
      expect(find_field('attendance_notes').value).to eq 'TEST'
    end
  end
end
