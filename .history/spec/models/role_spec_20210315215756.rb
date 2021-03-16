# frozen_string_literal: true

RSpec.describe Role, type: :model do
  subject(:role) {described_class.new(role_name: 'Admin')}

  it 'is valid with a name' do
    expect(role).to be_valid
  end

  it 'is not valid without a name' do
    role.role_name = nil
    expect(role).not_to be_valid
  end
end
