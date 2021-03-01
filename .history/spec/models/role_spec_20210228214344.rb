RSpec.describe Role, :type => :model do
  let(:frozen_time) { "25 May 2AM".to_datetime }
  before { Timecop.freeze(frozen_time) }
  after { Timecop.return }
  subject {
    described_class.new(session_datetime: DateTime.now)
  }
  
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without session_datetime" do
    subject.session_datetime = nil
    expect(subject).to_not be_valid
  end
  create_table "roles", force: :cascade do |t|
    t.string "role_name"
  end
end