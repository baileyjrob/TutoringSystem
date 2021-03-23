# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Course Request', type: :feature do
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
