# frozen_string_literal: true

RSpec.describe Role, type: :model do
  subject do
    described_class.new(role_name: 'Admin')
  end

  it 'is valid with a name' do
    expect(subject).to be_valid
  end

  it 'is not valid without a name' do
    subject.role_name = nil
    expect(subject).not_to be_valid
  end
end
