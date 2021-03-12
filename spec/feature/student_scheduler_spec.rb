# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Student scheduler', type: :feature do
  describe 'student scheduler' do
    it 'schedules a tutoring session' do
      # Create some data
      user1 = User.create!(first_name: 'John',
                           last_name: 'Doe',
                           email: 'john@tamu.edu',
                           password: 'T3st!!b')

      user2 = User.create!(first_name: 'Jane',
                           last_name: 'Doe',
                           email: 'jane@tamu.edu',
                           password: 'T3st!!c')

      user3 = User.create!(first_name: 'Jeff',
                           last_name: 'Doe',
                           email: 'jeff@tamu.edu',
                           password: 'T3st!!d')

      tsession1 = TutoringSession.create!(id: 1,
                                          tutor_id: user2.id,
                                          scheduled_datetime: Time.now,
                                          completed_datetime: nil,
                                          session_status: '')

      tsession2 = TutoringSession.create!(id: 2,
                                          tutor_id: user3.id,
                                          scheduled_datetime: Time.now,
                                          completed_datetime: nil,
                                          session_status: '')

      # Start at student index page
      visit 'student/index'
      expect(page).to have_content('Student Home Page')

      # Go to scheduling page
      find_button 'Schedule tutoring session'
      click_button 'Schedule tutoring session'
      expect(page).to have_content('Student Scheduling Page')

      # Cancel join and then go back and schedule
      find_button 'Cancel'
      click_button 'Cancel'
      expect(page).to have_content('Student Home Page')

      # Go back to scheduling page
      click_button 'Schedule tutoring session'
      expect(page).to have_content('Student Scheduling Page')

      # Join a session
      find_button 'Join session', id: tsession1.id
      find_button 'Join session', id: tsession2.id
      click_button 'Join session', id: tsession1.id

      # Expect to be at student index page
      expect(page).to have_content('Student Home Page')

      # Make sure join table worked
      @count = false
      TutoringSession.find(tsession1.id).users.each do |user|
        @count = true if user.id == user1.id
      end
      expect(@count).to eq(true)

      # Delete everything
      sessions = TutoringSession.all
      sessions.each do |session|
        session.users.destroy_all unless session.users.blank?
      end
      TutoringSession.delete_all
      User.delete_all
    end
  end
end
