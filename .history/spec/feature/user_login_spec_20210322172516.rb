# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TutoringSessionController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let(:tutor) do
    User.new(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu')
  end
  let(:scheduled_datetime) { '26 May 2021 08:00:00 +0000'.to_datetime }
  let(:beginning_of_week) { Date.today.beginning_of_week(start_day = :sunday) }

  before do
    Timecop.freeze(frozen_time)
    User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                email: 'admin@tamu.edu')
    visit('/users/sign_in/')
    fill_in 'user_email', with: 'tutor@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'

    find(:link_or_button, 'Log in').click
  end

  after { Timecop.return }

  describe 'SHOW' do
    it 'shows user' do
      admin = User.where(first_name: 'Admin').first
      visit("users/#{admin.id}")
      expect(page).to have_content('Admin User')
    end
  end
end
