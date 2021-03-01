require 'rails_helper'
RSpec.describe 'Student scheduler', type: :feature do
  describe 'student scheduler' do

    it 'schedules a tutoring session' do
      # Delete everything
      User.delete_all
      TutoringSession.delete_all

      # Create some data
      User.create(:id => 1,
                  :first_name => "John",
                  :last_name => "Doe",
                  :email => "john@doe.com"
      )

      User.create(:id => 2,
                  :first_name => "Jane",
                  :last_name => "Doe",
                  :email => "jane@doe.com"
      )

      User.create(:id => 3,
                  :first_name => "Jeff",
                  :last_name => "Doe",
                  :email => "jeff@doe.com"
      )

      TutoringSession.create(:id => 1,
                             :tutor_id => 2,
                             :scheduled_datetime => Time.now,
                             :completed_datetime => nil,
                             :session_status => ""
      )

      TutoringSession.create(:id => 2,
                             :tutor_id => 3,
                             :scheduled_datetime => Time.now,
                             :completed_datetime => nil,
                             :session_status => ""
      )

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
      find_button 'Join session', id: 1
      find_button 'Join session', id: 2
      click_button 'Join session', id: 1

      # Expect to be at student index page
      expect(page).to have_content('Student Home Page')

      # Delete everything
      User.delete_all
      TutoringSession.delete_all
    end
  end
end