# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Course Request', :no_auth, type: :feature do
  before do
    # Create some data
    user1 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM',
                         email: 'ben@tamu.edu', password: 'T3st!!f')

    # Signing in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"

    # go to course request page
    visit('/course_request/new')
  end

  describe 'Submitting a course request' do
    it 'tries to submit a course' do
      fill_in 'course_request_course_name_full', with: 'PHIL 101'
      find(:link_or_button, 'Create Course request').click
      visit('/course_request')
      expect(page).to have_content('PHIL 101')
    end
  end

  describe 'Returning to Tutor Matching page' do
    it 'returns to tutor matching page' do
      find(:link_or_button, 'Return to Tutor Matching').click
      expect(page).to have_content('Tutor Matching Page')
    end
  end

  User.destroy_all
  CourseRequest.destroy_all
end
