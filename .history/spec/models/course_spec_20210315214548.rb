# frozen_string_literal: true

RSpec.describe Course, type: :model do
  subject do
    described_class.new(id: 0, course_name: '301', department_id: @department.id)
  end

  before do
    @department = Department.new(department_name: 'MATH')
    @department.save
  end

  it 'is valid with a department and name' do
    expect(subject).to be_valid
  end

  it 'is not valid without a name' do
    subject.course_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a department' do
    subject.course_name = '301'
    subject.department_id = nil
    expect(subject).not_to be_valid
  end

  after do
    @department.delete
  end
end
