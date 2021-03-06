# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TutoringSessionExportHelper, type: :helper do
  filepath = 'spec/helpers/tutoring_hours_spec'
  let(:tutor) do
    User.create(
      first_name: 'Tutor',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'tutor@tamu.edu'
    )
  end
  let(:tutoring_sessions) do
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
  # let(:csv_string) { nil }

  # before do
  #   # Instead of output to file, output to string
  #   csv_string = nil
  #   allow(File).to receive(:open) {csv_string = CSV.generate}
  # end
  context 'when tutor is indeed a tutor' do
    before { tutor.roles << Role.create(role_name: 'Tutor') }

    it 'adds all completed tutoring hours' do
      tutor.tutoring_sessions.push(tutoring_sessions, 'confirmed', tutor)
      create_csv(start_date, end_date, "#{filepath}.csv")
      csv_table = CSV.read(Rails.root.join("#{filepath}.csv"), headers: true)
      expect([csv_table[0]['Tutor_Name'],
              csv_table[0]['Hours_Worked']]).to eq(['Tutor User', '3.0'])
    end

    it 'says zero hours when applicable' do
      # tutor does not have any tutoring sessions
      create_csv(start_date, end_date, "#{filepath}_2.csv")
      csv_table = CSV.read(Rails.root.join("#{filepath}_2.csv"), headers: true)
      expect([csv_table[0]['Tutor_Name'],
              csv_table[0]['Hours_Worked']]).to eq(['Tutor User', '0.0'])
    end
  end

  context 'when tutor is not actually a tutor' do
    it 'does not show them in the csv' do
      create_csv(start_date, end_date, "#{filepath}_3.csv")
      csv_table = CSV.read(Rails.root.join("#{filepath}_3.csv"), headers: true)
      expect(csv_table[0]).to be_nil
    end
  end

  describe 'emailing' do
    it 'sends emails' do
      mail_csv(start_date, end_date, "#{filepath}.csv")
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'emails with correct text' do
      mail_csv(start_date, end_date, "#{filepath}.csv")
      expect(ActionMailer::Base.deliveries[0].body.encoded)
        .to include('Thank you for using our service. '\
        'Your request has been rendered in a CSV and attached to this email.')
    end

    it 'attaches correct CSV' do
      mail_csv(start_date, end_date, "#{filepath}.csv")
      expect(ActionMailer::Base.deliveries[0].attachments[0].body.encoded.delete("\r")).to eq <<~CSV
        Tutor_Name,Hours_Worked
        Tutor User,3.0
      CSV
    end
  end
end
