# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TutoringSessionController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  let(:tutor) { User.where(first_name: 'Tutor', last_name: 'User').first }
  let(:scheduled_datetime) { '26 May 2021 08:00:00 +0000'.to_datetime }
  let(:beginning_of_week) { Date.today.beginning_of_week }

  after { Timecop.return }

  before do
    Timecop.freeze(frozen_time)
    User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a',
                email: 'admin@tamu.edu')
    User.create(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a',
                email: 'tutor@tamu.edu')

    visit('/users/sign_in/')
    fill_in 'user_email', with: 'tutor@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'

    find(:link_or_button, 'Log in').click
  end

  describe 'GET index' do
    it 'shows schedule at beginning of week (sunday)' do
      visit('/tutoring_session')
      expect(page).to have_content('May 24th, 2021')
    end

    it 'sets start_week cookie' do
      expect(get_me_the_cookie('start_week')).to eq(nil)
      visit('/tutoring_session')
      expect(get_me_the_cookie('start_week')[:value])
        .to eq(beginning_of_week.to_datetime.strftime('%Q'))
    end

    it 'increments week on increment cookie' do
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '<')
      create_cookie('week_offset', '1')
      visit('/tutoring_session')
      expect(page).to have_content('May 31st, 2021')
    end

    it 'decrements week on decrement cookie' do
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '<')
      create_cookie('week_offset', '-1')
      visit('/tutoring_session')
      expect(page).to have_content('May 23rd, 2021')
    end

    it 'increments week on increment click', js: true do
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '>')
      find(:link_or_button, '>').click
      expect(page).to have_content('May 31st, 2021')
    end

    it 'decrements week on decrement click', js: true do
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '<')
      find(:link_or_button, '<').click
      expect(page).to have_content('May 23rd, 2021')
    end

    it 'is able to click on button to create tutoring session' do
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, 'Add Session')
      find(:link_or_button, 'Add Session').click
      expect(page).to have_content('Create Tutoring Session')
    end

    it 'is able to see sessions' do
      tsession = TutoringSession.create(scheduled_datetime: scheduled_datetime, tutor_id: tutor.id)
      tsession.users << tutor

      visit('/tutoring_session')
      expect(page).to have_selector('.tsession')
    end
  end

  describe 'CREATE' do
    it 'creates session on form submission' do
      expect(TutoringSession.all.count).to eq(0)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with: scheduled_datetime
      uncheck 'repeat_session'
      find(:link_or_button, 'Create Tutoring session').click

      expect(page).not_to have_content('Create Tutoring Session')
      expect(TutoringSession.all.count).to eq(1)
      expect(TutoringSession.first.scheduled_datetime).to eq(scheduled_datetime)
    end

    it 'creates multiple sessions on form submission with repeat selected' do
      expect(TutoringSession.all.count).to eq(0)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with: scheduled_datetime
      check 'repeat_session'
      find(:link_or_button, 'Create Tutoring session').click

      expect(page).not_to have_content('Create Tutoring Session')
      first_session = TutoringSession.where(scheduled_datetime: scheduled_datetime).first
      # Calculate how many weeks are between the scheduled date and end of semester, then add 1 for the original week
      session_count = ((first_session.end_of_semester_datetime.to_time - first_session.scheduled_datetime.to_time) / 1.week).to_i + 1
      expect(TutoringSession.all.count).to eq(session_count)
    end

    it 'errors on no scheduled date time submission' do
      expect(TutoringSession.all.count).to eq(0)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with:
      find(:link_or_button, 'Create Tutoring session').click

      expect(page).to have_content('Create Tutoring Session')
      expect(TutoringSession.all.count).to eq(0)
    end

    it 'errors on session overlap' do
      expect(TutoringSession.all.count).to eq(0)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with: scheduled_datetime
      find(:link_or_button, 'Create Tutoring session').click

      expect(TutoringSession.all.count).to eq(1)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with: scheduled_datetime
      find(:link_or_button, 'Create Tutoring session').click

      expect(page).to have_content('Create Tutoring Session')
      expect(page).to have_content('overlaps with one of yours that is currently scheduled')
    end
  end

  describe 'SHOW' do
    it 'is able to view session details' do
      tsession = TutoringSession.create(scheduled_datetime: scheduled_datetime,
                                        tutor_id: tutor.id)
      tsession.users << tutor

      visit("/tutoring_session/#{tsession.id}")
      expect(page).to have_content('Session scheduled for May 26th, 2021 at 08:00 AM')
      expect(page).to have_content('Tutor User')
    end

    it 'is able to delete session', js: true do
      tsession = TutoringSession.create(scheduled_datetime: scheduled_datetime,
                                        tutor_id: tutor.id)
      tsession.users << tutor

      expect(TutoringSession.all.count).to eq(1)
      visit("/tutoring_session/#{tsession.id}")
      accept_confirm do
        find(:link_or_button, 'delete').click
      end
      expect(TutoringSession.all.count).to eq(0)
    end

    it 'is able to delete session and any repeating sessions at the same time',
       js: true do
      tsession = TutoringSession.create(scheduled_datetime: scheduled_datetime,
                                        tutor_id: tutor.id)
      tsession.users << tutor
      tsession2 = TutoringSession.create(scheduled_datetime: scheduled_datetime + 1.week,
                                         tutor_id: tutor.id)
      tsession2.users << tutor

      expect(TutoringSession.all.count).to eq(2)
      visit("/tutoring_session/#{tsession.id}")
      accept_confirm do
        find(:link_or_button, 'delete self and following repeats').click
      end
      expect(TutoringSession.all.count).to eq(0)
    end
  end

  describe 'UPDATE' do
    it 'is able to edit session details' do
      tsession = TutoringSession.create(scheduled_datetime: scheduled_datetime,
                                        tutor_id: tutor.id)
      tsession.users << tutor

      visit("/tutoring_session/#{tsession.id}")
      find(:link_or_button, 'edit').click

      expect(page).to have_content('Edit Tutoring Session')
      fill_in 'tutoring_session_scheduled_datetime', with: (scheduled_datetime + 1.hour)
      find(:link_or_button, 'Update Tutoring session').click

      expect(TutoringSession.all.count).to eq(1)
      expect(TutoringSession.first.users.count).to eq(1)
      expect(TutoringSession.first.scheduled_datetime).to eq((scheduled_datetime + 1.hour))
    end

    it 'errors on missing scheduled_datetime edit session details' do
      tsession = TutoringSession.create(scheduled_datetime: scheduled_datetime,
                                        tutor_id: tutor.id)
      tsession.users << tutor

      visit("/tutoring_session/#{tsession.id}")
      find(:link_or_button, 'edit').click

      expect(page).to have_content('Edit Tutoring Session')
      fill_in 'tutoring_session_scheduled_datetime', with: ''
      find(:link_or_button, 'Update Tutoring session').click
      expect(page).to have_content('Edit Tutoring Session')

      expect(TutoringSession.all.count).to eq(1)
    end
  end
end
