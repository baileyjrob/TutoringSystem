# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', type: :feature do
  before do
    # Create some data
    tutor_role = Role.create(role_name: 'Tutor')
    student_role = Role.create(role_name: 'Student')

    user1 = User.create!(id: 16, first_name: 'Ben', last_name: 'Doe', major: 'CHEM',
                         email: 'ben@tamu.edu', password: 'T3st!!f')
    user2 = User.create!(id: 17, first_name: 'Christine', last_name: 'Doe', major: 'MATH',
                         email: 'christine@tamu.edu', password: 'T3st!!g')
    tutor1 = User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH',
                          email: 'dakota@tamu.edu', password: 'T3st!!h')
    tutor1.roles << tutor_role
    user1.roles << student_role
    user2.roles << student_role

    # Signing in
    visit "users/#{user1.id}"
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    find(:link_or_button, 'Log in').click
    visit "/users/#{user1.id}"

    # go to tutor matching page
    visit('/course_request')
  end

  it 'visits tutor matching page' do
    expect(page).to have_content('Tutor Matching Page')
  end

  # Dakota is a tutor, Christine is not, Christine should not be here
  describe 'Available tutor matching' do
    it 'matches tutors using tutor majors' do
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      expect(page).to have_content('Dakota Doe Major: MATH')
    end
  end

  describe 'Available tutor matching' do
    it 'makes sure no students pop up in a tutor search' do
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      expect(page).not_to have_content('Christine Doe Major: MATH')
    end
  end

  # Make sure Ben doesn't show up
  describe 'No available tutor matching' do
    it 'tries to find a tutor' do
      fill_in 'filter_major', with: 'CHEM'
      find_button 'Find'
      click_button 'Find'
      expect(page).not_to have_content('Ben Doe Major: CHEM')
    end

    User.destroy_all
  end
end
