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
                            complete_datetime: '28 May 2021 09:00:00 +0000'.to_datetime,
                            session_status: 'complete',
                            tutor_id: tutor.id),
     TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime,
                            complete_datetime: '26 May 2021 09:00:00 +0000'.to_datetime,
                            session_status: 'complete',
                            tutor_id: tutor.id),
     TutoringSession.create(scheduled_datetime: '27 May 2021 08:00:00 +0000'.to_datetime,
                            complete_datetime: '27 May 2021 09:00:00 +0000'.to_datetime,
                            session_status: 'complete',
                            tutor_id: tutor.id)]
  end
  let(:start_date )
  it "adds all tutoring hours" do
    tutor.tutoring_sessions << tutoring_sessions

  end
end
