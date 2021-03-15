# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'users/show_schedule.html.erb', type: :view do
  let(:tutor) do
    User.new(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu')
  end

  let(:session1) do
    TutoringSession.new(tutor_id: 1, scheduled_datetime: '25 May 02:00:00 +0000'.to_datetime)
  end
  let(:session2) do
    TutoringSession.new(tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
  end
  let(:session3) do
    TutoringSession.new(tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
  end

  before do
    allow(User).to receive(:find).with(1) { tutor }
    assign(:sessions, [session1, session2, session3])
  end

  it 'shows a table' do
    render
    expect(rendered).to have_css('table')
  end

  it 'displays tutor\'s name and scheduled time' do
    render
    within 'table' do
      expect(rendered).to have_content('Tutor User')
      expect(rendered).to have_content('25 May 02:00:00 +0000'.to_datetime)
    end
  end
  it 'displays all scheduled sessions' do
    render
    within('table') do
      expect(page).to have_xpath(".//tr", :count => 3)
    end
  end

  it 'has the option for users to opt-out of sessions' do
    render
    expect(rendered).to have_content('Leave Session')
  end
end
