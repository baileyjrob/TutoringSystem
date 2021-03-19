require 'rails_helper'
RSpec.describe 'Student scheduler', type: :feature do
  describe 'student scheduler' do

    it 'schedules a tutoring session' do
      # Create some data
      Role.create!([{ role_name: 'Admin' },
                    { role_name: 'Tutor' },
                    { role_name: 'Student' },
                    { role_name: 'Spartan Tutor' }])

      user1 = User.create!(:first_name => "John",
                   :last_name => "Doe",
                   :email => "john@tamu.edu",
                   :password => "T3st!!b"
      )
      user1.roles << Role.find_by(role_name: "Student")

      user2 = User.create!(:first_name => "Jane",
                   :last_name => "Doe",
                   :email => "jane@tamu.edu",
                   :password => "T3st!!c"
      )
      user2.roles << Role.find_by(role_name: "Tutor")

      user3 = User.create!(:first_name => "Jeff",
                   :last_name => "Doe",
                   :email => "jeff@tamu.edu",
                   :password => "T3st!!d"
      )
      user3.roles << Role.find_by(role_name: "Tutor")

      tsession1 = TutoringSession.create!(:id => 1,
                             :tutor_id => user2.id,
                             :scheduled_datetime => Time.now + 100000,
                             :completed_datetime => nil,
                             :session_status => ""
      )

      tsession2 = TutoringSession.create!(:id => 2,
                             :tutor_id => user3.id,
                             :scheduled_datetime => Time.now + 100000,
                             :completed_datetime => nil,
                             :session_status => ""
      )

      tsession3 = TutoringSession.create!(:id => 3,
                                          :tutor_id => user3.id,
                                          :scheduled_datetime => Time.now - 1,
                                          :completed_datetime => nil,
                                          :session_status => ""
      )

      # Start at user home page
      visit 'users/' + user1.id.to_s

      # Go to scheduling page
      find_button 'Schedule tutoring session'
      click_button 'Schedule tutoring session'
      expect(page).to have_content('Student Scheduling Page')

      # Cancel join and then go back and schedule
      find_button 'Cancel'
      click_button 'Cancel'
      expect(page).to have_content(user1.first_name + ' ' + user1.last_name)

      # Go back to scheduling page
      click_button 'Schedule tutoring session'

      # Join a session
      find_button 'Join session', id: tsession1.id
      find_button 'Join session', id: tsession2.id
      expect(page).to_not have_button 'Join session', id: tsession3.id
      click_button 'Join session', id: tsession1.id

      # Expect to be at student index page
      expect(page).to have_content(user1.first_name + ' ' + user1.last_name)

      # Check that the session is no longer joinable
      click_button 'Schedule tutoring session'
      expect(page).to_not have_button 'Join session', id: tsession1.id
      find_button 'Join session', id: tsession2.id
      click_button 'Cancel'

      # Make sure join table worked
      joined = false
      TutoringSession.find(tsession1.id).users.each do |user|
        if user.id == user1.id
          joined = true
        end
      end
      expect(joined).to eq(true)

      # Delete all data created
      users = User.all
      users.each do |user|
        unless user.roles.blank?
          user.roles.destroy_all
        end
      end
      Role.delete_all
      sessions = TutoringSession.all
      sessions.each do |session|
        unless session.users.blank?
          session.users.destroy_all
        end
      end
      TutoringSession.delete_all
      User.delete_all
    end
  end
end