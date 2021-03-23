# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UsersController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let!(:user) {User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a', email: 'admin@tamu.edu')}
  let!(:tutor) {User.create(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu')}
  let!(:tutoring_session1) { TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime) }
  let!(:tutoring_session2) { TutoringSession.create(scheduled_datetime: '27 May 2021 08:00:00 +0000'.to_datetime) }
  let!(:tutoring_session3) { TutoringSession.create(scheduled_datetime: '28 May 2021 08:00:00 +0000'.to_datetime) }
  before do
    Timecop.freeze(frozen_time)
    tutor.save
    tutoring_session1.tutor_id = tutor.id
    tutoring_session2.tutor_id = tutor.id
    tutoring_session3.tutor_id = tutor.id
    tutoring_session1.save
    tutoring_session2.save
    tutoring_session3.save
    user.save
    user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]
    visit('/users/sign_in/')
    fill_in 'user_email', with: 'admin@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'
    find(:link_or_button, 'Log in').click
    visit(show_schedule_path)
  end
  it 'shows all of user\'s sessions' do
    expect(page).to have_content('May 26')
    expect(page).to have_content('May 27')
    expect(page).to have_content('May 28')

  end
  it 'properly deletes sessions', js: true do
    print page.body
    tr = find(:xpath, "//td[contains(text(),'May 26')]//parent::tr[1]") # get the parent tr of the td
    within(tr) do
      accept_confirm do
        find(:link_or_button, 'Leave Session').click
      end
    end
    expect(response).not_to have_content('May 26')
  end
  after do
    user.destroy
    tutoring_session1.destroy
    tutoring_session2.destroy
    tutoring_session3.destroy
    tutor.destroy
  end

  
  
end
