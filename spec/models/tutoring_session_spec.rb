# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TutoringSession, type: :model do
  let(:tutoring_session) { described_class.new(scheduled_datetime: frozen_time) }

  let(:frozen_time) { '25 May 02:00:00 CDT'.to_datetime }

  before { Timecop.freeze(frozen_time) }

  after { Timecop.return }

  it 'is valid with valid attributes' do
    expect(tutoring_session).to be_valid
  end

  it 'is not valid without scheduled_datetime' do
    tutoring_session.scheduled_datetime = nil
    expect(tutoring_session).not_to be_valid
  end

  it '.duration_datetime should be 1 hour' do
    expect(tutoring_session.duration_datetime).to eq(Time.zone.now + 1.hour)
  end

  it '.top_offset should be (2/24) * 100 %' do
    expect(tutoring_session.top_offset).to eq("#{(2 / 24.0) * 100}%")
  end

  it '.top_offset should be [(2 + 20/60) / 24] * 100 % for a 2:20AM Meeting' do
    tutoring_session.scheduled_datetime = Time.zone.now + 20.minutes
    expect(tutoring_session.top_offset).to eq("#{((2 + 20 / 60.0) / 24.0) * 100}%")
  end
end
