require 'rails_helper'
require '/spec/support/users_helpers'
RSpec.describe 'users/show_schedule.html.erb', type: :view do
  let(:tutor) { User.new(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu') }
  let(:session1) {TutoringSession.new(tutor_id: 1, scheduled_datetime: '25 May 02:00:00 +0000'.to_datetime)}
  let(:session2) {TutoringSession.new(tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)}
  let(:session3) {TutoringSession.new(tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)}
  before do
    allow(User).to receive(:find) {tutor}
    assign(:sessions, [session1, session2, session3])
  end
  it 'shows a table' do
    render
    expect(rendered).to have_css("table")
  end
  it 'displays all scheduled sessions' do
    render
    within 'table' do
      expect(rendered).to have_content('Tutor User')
      expect(rendered).to have_content('25 May 02:00:00 +0000'.to_datetime)
      expect(rendered).to have_content('26 May 02:00:00 +0000'.to_datetime)
      expect(rendered).to have_content('27 May 02:00:00 +0000'.to_datetime)
    end
  end
  it 'displays an error message when no user logged on' do
    current_user = nil
    render
    expect(rendered).to have_content('Error')
  end
  it 'has the option for users to opt-out of sessions' do
    render
    expect(rendered).to have_content('Leave Session')
  end
end