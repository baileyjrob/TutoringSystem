# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users trying to', type: :feature do
  let(:first_code) { 'asdasd' }
  let(:second_code) { '123123' }

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

    SpartanSession.create(session_datetime: Time.zone.now + 6000,
                          first_code: 'asdasd',
                          second_code: '123123')

    # Will need to sign in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"
  end

  after do
    SpartanSession.destroy_all
    User.destroy_all
  end

  describe 'checkin to spartan session' do
    it 'can see checkin button' do
      find_button 'Check In'
    end

    it 'can checkin to a session' do
      # Check in
      fill_in 'Code', with: first_code
      click_button 'Check In'

      # Make sure join table worked
      session = SpartanSessionUser.where(user_id: 1)
                                  .and(SpartanSessionUser.where(spartan_session_id: 1))
      expect(session.blank?).to eq(false)
    end

    it 'sets the first checkin time' do
      # Check in
      fill_in 'Code', with: first_code
      click_button 'Check In'

      # Make sure join table worked
      session = SpartanSessionUser.where(user_id: 1)
                                  .and(SpartanSessionUser.where(spartan_session_id: 1))
      expect(session.first.first_checkin.present?).to eq(true)
    end

    it 'updates page to checkout' do
      # Check in
      fill_in 'Code', with: first_code
      click_button 'Check In'

      expect(page).to have_button 'Check Out'
    end

    it 'doesn\'t accept bad codes' do
      # Check in
      fill_in 'Code', with: 'bad'
      click_button 'Check In'

      expect(page).to have_content('Invalid check in code!')
    end
  end

  describe 'checkout of spartan session' do
    before do
      # Check in
      fill_in 'Code', with: first_code
      click_button 'Check In'
    end

    it 'can checkout of a session' do
      # Check out
      fill_in 'Code', with: second_code
      click_button 'Check Out'

      # Make sure join table worked
      session = SpartanSessionUser.where(user_id: 1)
                                  .and(SpartanSessionUser.where(spartan_session_id: 1))
      expect(session.first.second_checkin.present?).to eq(true)
    end

    it 'updates page to say user attended' do
      # Check out
      fill_in 'Code', with: second_code
      click_button 'Check Out'

      expect(page).to have_content('You have attended this session')
    end

    it 'doesn\'t accept bad codes' do
      # Check in
      fill_in 'Code', with: 'bad'
      click_button 'Check Out'

      expect(page).to have_content('Invalid check in code!')
    end
  end
end
