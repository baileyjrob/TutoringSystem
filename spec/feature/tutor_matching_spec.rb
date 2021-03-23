# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', type: :feature do

  it 'visits tutor matching page' do
      visit('/tutor/index')
      expect(page).to have_content('Tutor Matching Page')
  end

  describe 'Available tutor matching' do
    it 'matches tutors using tutor majors' do
      # Create some data
      User.create!(id: 15, first_name: 'Adam', last_name: 'Doe', major: 'CHEM', email: 'adam@tamu.edu', password: 'T3st!!e')
      User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH', email: 'dakota@tamu.edu', password: 'T3st!!h')
      
      # Enter a department name for a tutor search
      visit('/tutor/index')
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      # Check what is on the tutor matching page
      expect(page).to have_content('Dakota Doe Major: MATH')
    end
    User.delete_all

  end

  describe 'No available tutor matching' do
    it 'tries to find a tutor' do
      # Create some data
      User.create!(id: 15, first_name: 'Adam', last_name: 'Doe', major: 'CHEM', email: 'adam@tamu.edu', password: 'T3st!!e')
      User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH', email: 'dakota@tamu.edu', password: 'T3st!!h')
       
      # Enter new department name that does not have available tutors
      visit('/tutor/index')
      fill_in 'filter_major', with: 'ENGR'
      find_button 'Find'
      click_button 'Find'
      # Check that there are no available tutors
      expect(page).to have_content('No Available Tutors')
    end

    User.delete_all
  end

  describe 'Submitting a course request' do
    it 'submits a course' do
      # Enter new department name that does not have available tutors
      visit('/tutor/index')
      fill_in 'filter_major', with: 'ENGR'
      find_button 'Find'
      click_button 'Find'
      # Enter requested course
      fill_in 'requested_course', with: 'PHIL 101'
      find_button 'Submit'
      click_button 'Submit'
      # Check if request is submitted
      expect(page).to have_content('Request Page')
    end
  end

  describe 'Returning to Tutor Matching page' do
    it 'returns to tutor matching page' do
      # Go back to tutor matching page
      visit('/tutor/request_submission')
      find_button('Return to Tutor Matching')
      click_button('Return to Tutor Matching')
      expect(page).to have_content('Tutor Matching Page')
    end
  end

end
