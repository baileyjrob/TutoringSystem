RSpec.describe Department, :type => :model do
  subject {
    described_class.new(department_name: "MATH")
  }
  
  it "is valid with a name" do
    expect(subject).to be_valid
  end
  it "is not valid without a name" do
    subject.department_name = nil;
    expect(subject).to_not be_valid
  end
end