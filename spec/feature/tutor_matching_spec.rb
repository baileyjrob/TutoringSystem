# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Tutor Matching', type: :feature do
  describe 'tutor matching' do
    it 'matches tutors using tutor majors' do
         # Create some data
         user5 = User.create!(id: 15, 
                              first_name: 'Adam', 
                              last_name: 'Doe', 
                              major: 'CHEM', 
                              email: "adam@tamu.edu", 
                              password: "T3st!!e")
         user6 = User.create!(id: 16, 
                              first_name: 'Ben', 
                              last_name: 'Doe', 
                              major: 'CHEM', 
                              email: "ben@tamu.edu", 
                              password: "T3st!!f")
         user7 = User.create!(id: 17, 
                              first_name: 'Christine', 
                              last_name: 'Doe', 
                              major: 'CHEM', 
                              email: "christine@tamu.edu", 
                              password: "T3st!!g")
         user8 = User.create!(id: 18, 
                              first_name: 'Dakota', 
                              last_name: 'Doe', 
                              major: 'MATH', 
                              email: "dakota@tamu.edu", 
                              password: "T3st!!h")
         user9 = User.create!(id: 19, 
                              first_name: 'Ethan', 
                              last_name: 'Doe', 
                              major: 'MATH', 
                              email: "ethan@tamu.edu", 
                              password: "T3st!!i")




    # Go to tutor matching page
    visit('/tutor/index')
    expect(page).to have_content('Tutor Matching Page')
    
    # Enter a department name for a tutor search
    fill_in "filter_major", with:'MATH'
    find_button 'Find'
    click_button 'Find'

    # Check what is on the tutor matching page
    expect(page).to have_content('Dakota Doe Major: MATH')    
    expect(page).to have_content('Ethan Doe Major: MATH')


    # Enter new department name that does not have available tutors
    fill_in "filter_major", with: 'ENGR'
    find_button 'Find'
    click_button 'Find'
    
    # Check that there are no available tutors
    expect(page).to have_content('No Available Tutors')

    # Enter requested course
    fill_in "requested_course", with: 'PHIL 101'
    find_button 'Submit'
    click_button 'Submit'

    # Check if request is submitted
    expect(page). to have_content('Request Page')

    # Go back to tutor matching page
    find_button('Return to Tutor Matching')
    click_button('Return to Tutor Matching')
    expect(page).to have_content('Tutor Matching Page')

      # Delete everything
      User.delete_all
    end
  end
end
