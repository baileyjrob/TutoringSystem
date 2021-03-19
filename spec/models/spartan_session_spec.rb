# frozen_string_literal: true

RSpec.describe SpartanSession, type: :model do
  subject do
    described_class.new(session_datetime: DateTime.now)
  end

  let(:frozen_time) { '25 May 2AM'.to_datetime }

  before { Timecop.freeze(frozen_time) }

  after { Timecop.return }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without session_datetime' do
    subject.session_datetime = nil
    expect(subject).not_to be_valid
  end
end
