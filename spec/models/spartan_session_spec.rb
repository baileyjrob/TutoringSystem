# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpartanSession, type: :model do
  subject(:spartan_session) do
    described_class.new(session_datetime: DateTime.now,
                        first_code: 'sad',
                        second_code: 'das')
  end

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

  it 'is not valid without first_code' do
    spartan_session.first_code = nil
    expect(spartan_session).not_to be_valid
  end

  it 'is not valid without second_code' do
    spartan_session.second_code = nil
    expect(spartan_session).not_to be_valid
  end
end
