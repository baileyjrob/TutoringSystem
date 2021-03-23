# frozen_string_literal: true

RSpec.describe Department, type: :model do
  subject(:department) { described_class.new(department_name: 'MATH') }

  it 'is valid with a name' do
    expect(department).to be_valid
  end

  it 'is not valid without a name' do
    department.department_name = nil
    expect(department).not_to be_valid
  end
end
