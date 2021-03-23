require 'rails_helper'
RSpec.describe 'users/show_schedule.html.erb', type: :view do
  let(:tutor) { User.new(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu') }
  let(:session1) {TutoringSession.new(tutor_id: 1, scheduled_datetime: '25 May 02:00:00 +0000'.to_datetime)}
  let(:session2) {TutoringSession.new(tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)}
  let(:session3) {TutoringSession.new(tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)}
  before(:all) do
    allow(User).to receive(:find) {tutor}
    allow(TutoringSession).to receive(:joins) {[session1, session2, session3]}
  end
  it 'routes to the page' do
    expect(:get => "/users/schedule").to route_to("users#show_schedule")
  end
  it 'shows a table' do
    expect(rendered).to have_content("table")
  end
  it 'displays all scheduled sessions'
  it 'displays scheduled date/time of session'
  it 'displays an error message when no user logged on'
  it 'has the option for users to opt-out of sessions'
end