# frozen_string_literal: true

RSpec.describe SpartanSession, type: :model do
  subject(:spartan_session) {described_class.new(session_datetime: DateTime.now)}

  let(:frozen_time) { '25 May 2AM'.to_datetime }

  before { Timecop.freeze(frozen_time) }

  after { Timecop.return }

  it 'is valid with valid attributes' do
    expect(spartan_session).to be_valid
  end

  it 'is not valid without session_datetime' do
    spartan_session.session_datetime = nil
    expect(spartan_session).not_to be_valid
  end
end
