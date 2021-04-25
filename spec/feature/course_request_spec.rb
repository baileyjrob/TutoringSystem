# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Course Request', :no_auth, type: :feature do
  before do
    # Create some data
    admin_role = Role.create(role_name: 'Admin')
    user1 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM',
                         email: 'ben@tamu.edu', password: 'T3st!!f')

    user1.roles << admin_role

    # Signing in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"

    # Put one request in first
    visit('/course_request/new')
    fill_in 'course_request_course_name_full', with: 'CSCE 431'
    find(:link_or_button, 'Create Course request').click

    # go to course request page
    visit('/course_request/new')
  end

  # only 1 course should be present
  describe 'Admin view of course requests' do
    it 'checks if old course requests are present' do
      find(:link_or_button, 'Admin Pages').click
      find(:link_or_button, 'See Course Requests').click
      expect(page).to have_xpath('.//tr', count: 1)
    end
  end

  describe 'Returning to Tutor Matching page' do
    it 'returns to tutor matching page' do
      find(:link_or_button, 'Return to Tutor Matching').click
      expect(page).to have_content('Tutor Matching Page')
    end
  end

  describe 'Admin clearing course requests' do
    it 'destroys all requests' do
      find(:link_or_button, 'Admin Pages').click
      find(:link_or_button, 'See Course Requests').click
      find(:link_or_button, 'Clear All Requests').click
      expect(page).not_to have_content('CSCE 431')
    end
  end

  User.destroy_all
  CourseRequest.destroy_all
  Role.destroy_all
end
