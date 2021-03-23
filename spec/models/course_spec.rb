# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  subject(:course) { described_class.new(id: 0, course_name: '301', department_id: department.id) }

  let(:department) { Department.new(department_name: 'MATH') }

  before do
    department.save
  end

  after do
    department.delete
  end

  it 'is valid with a department and name' do
    expect(course).to be_valid
  end

  it 'is not valid without a name' do
    course.course_name = nil
    expect(course).not_to be_valid
  end

  it 'is not valid without a department' do
    course.course_name = '301'
    course.department_id = nil
    expect(course).not_to be_valid
  end
end
