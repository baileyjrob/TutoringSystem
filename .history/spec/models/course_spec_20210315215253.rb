# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:department) {Department.new(department_name: 'MATH')}

  subject do
    described_class.new(id: 0, course_name: '301', department_id: department.id)
  end

  before do
    department.save
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
    department.delete
  end
end
