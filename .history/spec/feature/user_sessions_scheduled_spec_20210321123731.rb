# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UsersController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let(:user) {User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a', email: 'admin@tamu.edu')}
  let(:tutor) {User.create(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu')}
  let(:tutoring_session1) { TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime) }
  let(:tutoring_session2) { TutoringSession.create(scheduled_datetime: '27 May 2021 08:00:00 +0000'.to_datetime) }
  let(:tutoring_session3) { TutoringSession.create(scheduled_datetime: '28 May 2021 08:00:00 +0000'.to_datetime) }
  after do
    tutoring_session1.destroy
    tutoring_session2.destroy
    tutoring_session3.destroy
    user.destroy
  end

  before do
    Timecop.freeze(frozen_time)

    visit('/users/sign_in/')
    fill_in 'user_email', with: 'admin@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'
    tutoring_session1.save
    tutoring_session2.save
    tutoring_session3.save
    user.save
    user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]

    find(:link_or_button, 'Log in').click
  end
  it 'shows all of user\'s sessions' do
    visit('/users/schedule/')
    expect(page).to have_content('26 May 2021')
    expect(page).to have_content('27 May 2021')
    expect(page).to have_content('28 May 2021')

  end
  it 'properly deletes sessions' do
    visit('/users/schedule/')
    accept_confirm do
      find(:link_or_button, 'Leave Session').click
    end
    expect(page).not_to have_content('26 May 2021')
  end

  
  
end
