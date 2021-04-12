# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UsersController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let(:admin) { User.where(first_name: 'Tutor', last_name: 'User').first }
  let(:user) { User.where(first_name: 'User2', last_name: 'User').first }

  after { Timecop.return }

  before do
    Timecop.freeze(frozen_time)
    Role.delete_all

    a = User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                    email: 'admin@tamu.edu')
    User.create(first_name: 'User1', last_name: 'User', password: 'T3st!!a',
                email: 'User1@tamu.edu')
    User.create(first_name: 'User2', last_name: 'User', password: 'T3st!!a',
                email: 'User2@tamu.edu')
    User.create(first_name: 'User3', last_name: 'User', password: 'T3st!!a',
                email: 'User3@tamu.edu')
    ar = Role.create(role_name: 'Admin')

    Role.create(role_name: 'Student')
    a.roles << ar
    a.save

    visit('/users/sign_in/')
    fill_in 'user_email', with: 'admin@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'

    find(:link_or_button, 'Log in').click
  end

  describe 'GET Index' do
    it 'shows all users for admin' do
      visit('/users/')
      expect(page).to have_xpath(".//table//tr[@class='userInfo']", count: 4)
    end

    it 'does not show for non admins' do
      visit('/users/')
      find(:link_or_button, 'Sign out').click

      visit('/users/')
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  describe 'GET Edit' do
    it 'is able to click to edit user' do
      visit('/users/')
      find(:css, "a[href=\"/users/#{user.id}/edit\"]").click
      expect(page).to have_content('Edit User')
    end

    it 'changes name on proper submission' do
      visit("/users/#{user.id}/edit")
      fill_in 'user_first_name', with: 'A New User Name'
      find(:css, "#user_role_ids_[value='#{Role.find_by(role_name: 'Student').id}']").set(true)
      find(:link_or_button, 'Update').click

      expect(page).to have_content('A New User Name')
    end
  end
end
