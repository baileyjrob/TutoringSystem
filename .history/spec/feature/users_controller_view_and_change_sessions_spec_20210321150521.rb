# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UsersController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let!(:user) do
    User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                email: 'admin@tamu.edu')
  end
  let!(:tutoring_session1) do
    TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime, tutor_id: user.id)
  end
  let!(:tutoring_session2) do
    TutoringSession.create(scheduled_datetime: '27 May 2021 08:00:00 +0000'.to_datetime)
  end
  let!(:tutoring_session3) do
    TutoringSession.create(scheduled_datetime: '28 May 2021 08:00:00 +0000'.to_datetime)
  end

  before do
    Timecop.freeze(frozen_time)
    tutoring_session1.tutor_id = user.id #We don't actually care who tutor is
    tutoring_session2.tutor_id = user.id
    tutoring_session3.tutor_id = user.id
    user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]
    visit('/users/sign_in/')
    fill_in 'user_email', with: 'admin@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'
    find(:link_or_button, 'Log in').click
    visit(show_schedule_path)
  end

  after do
    Timecop.return
    tutoring_session1.destroy
    tutoring_session2.destroy
    tutoring_session3.destroy
    user.destroy
  end

  it 'shows all of user\'s sessions' do
    expect(page).to have_content('May 26')
    expect(page).to have_content('May 27')
    expect(page).to have_content('May 28')
  end

  it 'properly deletes sessions', js: true do
    tr = find(:xpath, "//td[contains(text(),'May 26')]//parent::tr[1]") # get row with date
    within(tr) do
      accept_confirm do
        find(:link_or_button, 'Leave Session').click
      end
    end
    expect(page).not_to have_content('May 26')
  end
end
