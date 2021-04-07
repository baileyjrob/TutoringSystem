# frozen_string_literal: true

require 'rails_helper'
require './spec/services/select_date_service'
describe 'view tutoring hours', type: :feature do
  include SelectDateHelper
  let(:admin) do
    user = User.create(
      first_name: 'Admin',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'admin@tamu.edu'
    )
    user.roles << Role.create(role_name: 'Admin')
    return user
  end
  let(:tutor) do
    user = User.create(
      first_name: 'Tutor',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'tutor@tamu.edu'
    )
    user.roles << Role.create(role_name: 'Tutor')
    return user
  end
  let!(:tutoring_sessions) do
    [TutoringSession.create(scheduled_datetime: '28 May 2021 08:00:00 +0000'.to_datetime,
                            completed_datetime: '28 May 2021 09:00:00 +0000'.to_datetime,
                            session_status: 'Confirmed',
                            tutor_id: tutor.id),
     TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime,
                            completed_datetime: '26 May 2021 09:00:00 +0000'.to_datetime,
                            session_status: 'Confirmed',
                            tutor_id: tutor.id),
     TutoringSession.create(scheduled_datetime: '27 May 2021 08:00:00 +0000'.to_datetime,
                            completed_datetime: '27 May 2021 09:00:00 +0000'.to_datetime,
                            session_status: 'Confirmed',
                            tutor_id: tutor.id)]
  end
  let(:start_date) { '19 January 2021 08:00:00 +0000'.to_datetime }
  let(:end_date) { '30 May 2021 08:00:00 +0000'.to_datetime }

  before do
    visit('/users/sign_in/')
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: 'T3st!!a'
    find(:link_or_button, 'Log in').click
    visit('/users/admin_view_hours')
  end

  context 'with proper time input' do
    before do
      select_date(start_date, from: 'start_time')
      select_date(end_date, from: 'end_time')
      tutor.tutoring_sessions.push(tutoring_sessions, 'confirmed', tutor)
    end

    it 'creates a correct CSV file' do
      find(:link_or_button, 'Search').click
      csv_table = CSV.read(Rails.root.join('public/tutoring_hours.csv'), headers: true)
      expect([csv_table[0]['Tutor_Name'],
              csv_table[0]['Hours_Worked']]).to eq(['Tutor User', '3.0'])
    end

    it 'sends an email' do
      expect { find(:link_or_button, 'Search').click }.to change {
                                                            ActionMailer::Base.deliveries.count
                                                          }.by(1)
    end

    it 'email has correct data' do
      find(:link_or_button, 'Search').click
      expect(ActionMailer::Base.deliveries[0].attachments[0].body.encoded.delete("\r")).to eq <<~CSV
        Tutor_Name,Hours_Worked
        Tutor User,3.0
      CSV
    end
  end

  context 'with improper time input' do
    before do
      select_date(start_date, from: 'end_time')
      select_date(end_date, from: 'start_time')
    end

    it 'does not sends an email' do
      expect { find(:link_or_button, 'Search').click }.to change {
                                                            ActionMailer::Base.deliveries.count
                                                          }.by(0)
    end
  end
end
