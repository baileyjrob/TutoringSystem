RSpec.describe SpartanSession, :type => :model do
  let(:frozen_time) { "25 May 2AM".to_datetime }
  before { Timecop.freeze(frozen_time) }
  after { Timecop.return }
  subject {
    described_class.new(scheduled_datetime: DateTime.now)
  }
  
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without scheduled_datetime" do
    subject.scheduled_datetime = nil
    expect(subject).to_not be_valid
  end

  it ".duration_datetime should be 1 hour" do 
    expect(subject.duration_datetime).to eq(DateTime.now + 1.hour)
  end

  it ".top_offset should be (2/24) * 100 %" do
    expect(subject.top_offset).to eq(((2/24.0) * 100).to_s + '%')
  end

  it ".top_offset should be [(2 + 20/60) / 24] * 100 % for a 2:20AM Meeting" do
    subject.scheduled_datetime = DateTime.now + 20.minute
    expect(subject.top_offset).to eq((((2 + 20/60.0)/24.0) * 100).to_s + '%')
  end
end