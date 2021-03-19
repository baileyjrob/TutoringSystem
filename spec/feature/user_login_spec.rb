require 'rails_helper'
RSpec.describe TutoringSessionController, type: :feature do
  let(:frozen_time) { '25 May 02:00:00 +0000'.to_datetime }
  before { 
    Timecop.freeze(frozen_time) 
    User.create(first_name: 'Admin', last_name: 'User', password: 'T3st!!a', email: 'admin@tamu.edu') 
  }
  
  after { Timecop.return }

  let(:tutor) { User.new(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu') }
  let(:scheduled_datetime) { '26 May 2021 08:00:00 +0000'.to_datetime }
  let(:beginning_of_week) { Date.today.beginning_of_week(start_day = :sunday) }
  
  describe 'SHOW' do 
    it 'should show user' do 
      admin = User.where(first_name: 'Admin').first
      visit('users/' + admin.id.to_s)
      expect(page).to have_content('Admin User')
    end 
  end
end