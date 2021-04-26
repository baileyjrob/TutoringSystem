# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseRequest, type: :model do
  subject(:course_request) { described_class.new(course_name_full: 'MATH 308') }

  it 'is valid with a request' do
    expect(course_request).to be_valid
  end

  it 'is not valid without a request' do
    course_request.course_name_full = nil
    expect(course_request).not_to be_valid
  end
end
