# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', :no_auth, type: :feature do
  before do
    # Create some data
    Role.create!([{ role_name: 'Admin' },
                  { role_name: 'Tutor' },
                  { role_name: 'Student' },
                  { role_name: 'Spartan Tutor' }])

    user = User.create!(first_name: 'Admin',
                        last_name: 'Doe',
                        email: 'admin@tamu.edu',
                        password: 'T3st!!b')
    user.roles << Role.find_by(role_name: 'Admin')

    # Will need to sign in
    visit "users/#{user.id}"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find(:link_or_button, 'Log in').click

    # Go to spartan sessions page
    click_link 'Admin Pages'
    click_link 'Spartan Session Index'
  end

  describe 'can access the spartan session creation page' do
    let(:time) { Time.zone.now }

    before do
      click_button 'New Spartan Session'
    end

    it 'successfully' do
      expect(page).to have_content 'Create Spartan Session'
    end

    it 'and cancel' do
      find(:link_or_button, 'Cancel').click
      find_button 'New Spartan Session'
    end

    it 'to create a session and return to list page' do
      fill_in 'semester', with: 'TEST'
      fill_in 'session_datetime', with: time.strftime('%Y-%m-%dT%T')
      fill_in 'check_in_code', with: 'asd'
      fill_in 'check_out_code', with: '123'
      click_button 'Save'
      find_button 'New Spartan Session'
    end

    it 'to create a session successfully' do
      fill_in 'semester', with: 'TEST'
      fill_in 'session_datetime', with: time.strftime('%Y-%m-%dT%T')
      fill_in 'check_in_code', with: 'asd'
      fill_in 'check_out_code', with: '123'
      click_button 'Save'
      expect(SpartanSession.find_by(semester: 'TEST', first_code: 'asd',
                                    second_code: '123')).to be_valid
    end
  end

  describe 'can manipulate a spartan session' do
    let(:time) { Time.zone.now }

    before do
      SpartanSession.create(id: 1,
                            semester: 'TEST',
                            session_datetime: time,
                            first_code: 'asdasd',
                            second_code: '123123')

      # Go to spartan sessions page
      click_link 'Admin Pages'
      click_link 'Spartan Session Index'
    end

    it 'by reaching the edit page' do
      click_button 'Edit'
      expect(page).to have_content 'Update Spartan Session'
    end

    it 'in the edit page where it maintains its values' do
      click_button 'Edit'
      expect(find_field('Semester').value).to eq 'TEST'
      expect(find_field('Check in code').value).to eq 'asdasd'
      expect(find_field('Check out code').value).to eq '123123'
    end

    it 'by updating values' do
      click_button 'Edit'
      fill_in 'Semester', with: 'TEST2'
      click_button 'Update Spartan session'
      expect(SpartanSession.find(1).semester).to eq 'TEST2'
    end

    it 'by deleting the session' do
      click_button 'Delete'
      expect(SpartanSession.find_by(id: 1).blank?).to eq true
    end
  end
end
