# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', type: :feature do
  before do
    # Create some data
    User.create!(id: 15, first_name: 'Adam', last_name: 'Doe', major: 'CHEM',
                 email: 'adam@tamu.edu', password: 'T3st!!e')
    User.create!(id: 18, first_name: 'Dakota', last_name: 'Doe', major: 'MATH',
                 email: 'dakota@tamu.edu', password: 'T3st!!h')
  end

  it 'visits tutor matching page' do
    visit('/tutor/index')
    expect(page).to have_content('Tutor Matching Page')
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
end
