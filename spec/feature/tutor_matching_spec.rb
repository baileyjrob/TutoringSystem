# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', type: :feature do

  it 'visits tutor matching page' do
      visit('/tutor/index')
      expect(page).to have_content('Tutor Matching Page')
  end

  before do
    # Create some data
    User.create!(id: 15, first_name: 'Adam', last_name: 'Doe', major: 'CHEM', email: 'adam@tamu.edu', password: 'T3st!!e')
    User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH', email: 'dakota@tamu.edu', password: 'T3st!!h')
  end
  describe 'Available tutor matching' do
    it 'matches tutors using tutor majors' do
      visit('/tutor/index')
      fill_in 'filter_major', with: 'MATH'
      find_button 'Find'
      click_button 'Find'
      expect(page).to have_content('Dakota Doe Major: MATH')
    end

  end

  describe 'No available tutor matching' do
    it 'tries to find a tutor' do
      visit('/tutor/index')
      fill_in 'filter_major', with: 'ENGR'
      find_button 'Find'
      click_button 'Find'
      expect(page).to have_content('No Available Tutors')
    end

    User.delete_all
  end

  before do
    visit('/tutor/index')
    fill_in 'filter_major', with: 'ENGR'
    find_button 'Find'
    click_button 'Find'
  end

  describe 'Submitting a course request' do
    it 'submits a course' do
      fill_in 'requested_course', with: 'PHIL 101'
      find_button 'Submit'
      click_button 'Submit'
      expect(page).to have_content('Request Page')
    end
  end

  describe 'Returning to Tutor Matching page' do
    it 'returns to tutor matching page' do
      visit('/tutor/request_submission')
      find_button('Return to Tutor Matching')
      click_button('Return to Tutor Matching')
      expect(page).to have_content('Tutor Matching Page')
    end
  end

end
