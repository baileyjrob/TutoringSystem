# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TutoringSessionExportHelper, type: :helper do
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

  it 'adds all tutoring hours' do
    tutor.tutoring_sessions << tutoring_sessions
    create_csv(start_date, end_date,
                               'spec/helpers/tutoring_hours_spec.csv')
    csv_table = CSV.read(Rails.root.join('spec/helpers/tutoring_hours_spec.csv'), headers: true)
    expect(csv_table[0]).to eq(['Tutor User', '3'])
  end
end
