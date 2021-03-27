# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Student scheduler', type: :feature do
  describe 'student scheduler' do
    let(:student_id) { 1 }
    let(:student_name) { 'John Doe' }
    let(:join_id) { 1 }
    let(:remain_id) { 2 }
    let(:early_id) { 3 }

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

      user2 = User.create!(first_name: 'Jane',
                           last_name: 'Doe',
                           email: 'jane@tamu.edu',
                           password: 'T3st!!c')
      user2.roles << Role.find_by(role_name: 'Tutor')

      user3 = User.create!(first_name: 'Jeff',
                           last_name: 'Doe',
                           email: 'jeff@tamu.edu',
                           password: 'T3st!!d')
      user3.roles << Role.find_by(role_name: 'Tutor')

      user4 = User.create!(first_name: 'James',
                           last_name: 'Doe',
                           email: 'james@tamu.edu',
                           password: 'T3st!!e')
      user4.roles << Role.find_by(role_name: 'Student')

      TutoringSession.create!(id: 1,
                              tutor_id: user2.id,
                              scheduled_datetime: Time.zone.now + 100_000,
                              completed_datetime: nil,
                              session_status: '')

      TutoringSession.create!(id: 2,
                              tutor_id: user3.id,
                              scheduled_datetime: Time.zone.now + 100_000,
                              completed_datetime: nil,
                              session_status: '')

      TutoringSession.create!(id: 3,
                              tutor_id: user3.id,
                              scheduled_datetime: Time.zone.now - 1,
                              completed_datetime: nil,
                              session_status: '')

      # Will need to sign in
      visit "users/#{user1.id}"
      fill_in 'user_email', with: user1.email
      fill_in 'user_password', with: user1.password
      find(:link_or_button, 'Log in').click
    end

    after do
      TutoringSession.destroy_all
      User.destroy_all
    end

    it 'can get to the scheduling page' do
      # Go to scheduling page
      find_link 'Schedule Tutoring Session'
      click_link 'Schedule Tutoring Session'
      expect(page).to have_content('Student Scheduling Page')
    end

    it 'can let a user cancel scheduling' do
      # Start at scheduling page
      click_link 'Schedule Tutoring Session'

      # Cancel join and then go back and schedule
      find_button 'Cancel'
      click_button 'Cancel'
      expect(page).to have_content(student_name)
    end

    it 'can can filter out early time stamps' do
      # Go to scheduling page
      click_link 'Schedule Tutoring Session'

      # Check available sessions
      find_button 'Join session', id: join_id
      find_button 'Join session', id: remain_id
      expect(page).not_to have_button 'Join session', id: early_id
    end

    it 'returns to the home page after joining a session' do
      # Go to scheduling page
      click_link 'Schedule Tutoring Session'

      # Join a session
      click_button 'Join session', id: join_id

      # Expect to be at student index page
      expect(page).to have_content(student_name)
    end

    it 'can successfully join a session' do
      # Go to scheduling page
      click_link 'Schedule Tutoring Session'

      # Join a session
      click_button 'Join session', id: join_id

      # Make sure join table worked
      tsession = TutoringSession.find(join_id)
      expect(tsession.users.find_by(id: student_id).blank?).to eq(false)
    end

    it 'prevents users from joining a session they joined previously' do
      # Go to scheduling page
      click_link 'Schedule Tutoring Session'

      # Join a session
      click_button 'Join session', id: join_id

      # Check that the session is no longer joinable
      click_link 'Schedule Tutoring Session'
      expect(page).not_to have_button 'Join session', id: join_id
      find_button 'Join session', id: remain_id
    end

    it 'only schedules sessions for the current user' do
      visit "/users/4"

      # Go to scheduling page
      click_link 'Schedule Tutoring Session'

      # Join a session
      click_button 'Join session', id: join_id

      # Make sure the CURRENT user joined the session
      tsession = TutoringSession.find(join_id)
      expect(tsession.users.find_by(id: student_id).blank?).to eq(false)
    end
  end
end
