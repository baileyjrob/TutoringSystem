RSpec.describe Course, :type => :model do
  @department = nil
  before {
    @department = Department.new(department_name: "MATH")
    @department.save
  }
  after{
    @deparment.destroy
  }
  subject {
    described_class.new(id: 0, course_name: '301', department_id: @department.id)
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