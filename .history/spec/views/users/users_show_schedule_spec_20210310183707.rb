require 'rails_helper'
RSpec.describe 'users/show_schedule.html.erb', type: :view do
  before(:all) do
    loginUser = double('user')
    session1 = double('tutoring_session')
    session2 = double('tutoring_session')
    session3 = double('tutoring_session')
    allow(session1).to receive(:tutor_id) {1}
    allow(session1).to receive(:scheduled_datetime) {1}
    allow(session2).to receive(:tutor_id) {2}
    allow(session2).to receive(:scheduled_datetime) {2}
    allow(session1).to receive(:tutor_id) {3}
    allow(session1).to receive(:scheduled_datetime) {3}
    allow(TutoringSession).to receive(:joins) {session1, session2, session3}
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