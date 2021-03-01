RSpec.describe Course, :type => :model do
  before {
    @department = Department.new(department_id: 0, department_name: "MATH")
  }
  subject {
    described_class.new(course_name: '301', department_id: @department.department_id)
  }
  
  it "is valid with a department and name" do
    expect(subject).to be_valid
  end
  it "is not valid without a name" do
    subject.course_name = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a department" do
    subject.course_name = '301'
    subject.department_id = nil
    expect(subject).to_not be_valid
  end
end