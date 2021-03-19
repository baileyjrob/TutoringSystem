RSpec.describe Role, :type => :model do
  subject {
    described_class.new(role_name: "Admin")
  }
  
  it "is valid with a name" do
    expect(subject).to be_valid
  end
  it "is not valid without a name" do
    subject.role_name = nil;
    expect(subject).to_not be_valid
  end
end