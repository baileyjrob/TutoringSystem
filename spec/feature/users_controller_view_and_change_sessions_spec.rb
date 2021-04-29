# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UsersController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let!(:user) do
    User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                email: 'admin@tamu.edu')
  end
  let!(:tutoring_session1) do
    TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime,
                           tutor_id: user.id)
  end
  let!(:tutoring_session2) do
    TutoringSession.create(scheduled_datetime: '27 May 2021 08:00:00 +0000'.to_datetime,
                           tutor_id: user.id)
  end
  let!(:tutoring_session3) do
    TutoringSession.create(scheduled_datetime: '28 May 2021 08:00:00 +0000'.to_datetime,
                           tutor_id: user.id)
  end

  before do
    Timecop.freeze(frozen_time)
    TutoringSessionUser.create(tutoring_session: tutoring_session1, user: user,
                               link_status: 'pending')
    TutoringSessionUser.create(tutoring_session: tutoring_session2, user: user,
                               link_status: 'pending')
    TutoringSessionUser.create(tutoring_session: tutoring_session3, user: user,
                               link_status: 'pending')

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
    expect(page).to have_xpath(".//table//tr[@class='tutoringSession']", count: 3)
  end

  it 'properly deletes sessions', js: true do
    tr = find(:xpath, "//td[contains(text(),'May 26')]//parent::tr[1]") # get row with date
    within(tr) { accept_confirm { find(:link_or_button, 'Cancel Session').click } }
    expect(page).not_to have_content('May 26')
  end

  it 'displays confirm message upon deletion', js: true do
    tr = find(:xpath, "//td[contains(text(),'May 27')]//parent::tr[1]")
    within(tr) { accept_confirm { find(:link_or_button, 'Cancel Session').click } }
    expect(page).to have_content('Session Cancelled')
  end
end
