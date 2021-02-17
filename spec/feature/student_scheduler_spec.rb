require 'rails_helper'
RSpec.describe 'Student scheduler', type: :feature do
  describe 'student scheduler' do
    it 'schedules a tutoring session for the student' do
      # Start at student index page and create fake data
      visit 'student/index'
      find_button 'Create temp data'
      expect(page).to have_content('Student Home Page')
      click_button 'Create temp data'

      # Go schedule a tutoring session
      find_button 'Schedule tutoring session'
      click_button 'Schedule tutoring session'
      expect(page).to have_content('Student Scheduling Page')

      # Cancel join and then go back and schedule
      find_button 'Cancel'
      click_button 'Cancel'
      click_button 'Schedule tutoring session'
      expect(page).to have_content('Student Scheduling Page')
      find_button 'Join session', id: 1
      find_button 'Join session', id: 2
      click_button 'Join session', id: 1

      # Expect to be at student index page
      expect(page).to have_content('Student Home Page')

      # Delete fake data
      find_button 'Delete temp data'
      click_on 'Delete temp data'
    end
  end
end