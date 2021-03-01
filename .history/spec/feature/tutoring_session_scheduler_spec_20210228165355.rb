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
  
  describe 'GET index' do 
    it 'should show schedule at beginning of week (sunday)' do 
      visit('/tutoring_session')
      expect(page).to have_content('May 23rd, 2021')
    end 
    
    it 'should set start_week cookie' do 
      expect(get_me_the_cookie('start_week')).to eq(nil)
      visit('/tutoring_session')
      expect(get_me_the_cookie('start_week')[:value]).to eq(beginning_of_week.to_datetime.strftime('%Q'))
    end  

    it 'should increment week on increment cookie' do 
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '<')
      create_cookie('week_offset', '1')
      visit('/tutoring_session')
      expect(page).to have_content('May 30th, 2021')
    end
    
    it 'should decrement week on decrement cookie' do 
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '<')
      create_cookie('week_offset', '-1')
      visit('/tutoring_session')
      expect(page).to have_content('May 22nd, 2021')
    end 

    it 'should increment week on increment click', :js => true do 
      visit("/tutoring_session")
      expect(page).to have_selector(:link_or_button, '>')
      find(:link_or_button, '>').click
      expect(page).to have_content('May 30th, 2021')
    end  

    it 'should decrement week on decrement click', :js => true do 
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, '<')
      find(:link_or_button, '<').click
      expect(page).to have_content('May 22nd, 2021')
    end

    it 'should be able to click on button to create tutoring session' do 
      visit('/tutoring_session')
      expect(page).to have_selector(:link_or_button, 'Add Session')
      find(:link_or_button, 'Add Session').click
      expect(page).to have_content('Create Tutoring Session')
    end  
    
    it 'should be able to see sessions' do 
      tsession = TutoringSession.create(:scheduled_datetime => scheduled_datetime)
      tsession.users << tutor

      visit('/tutoring_session')
      expect(page).to have_selector('.tsession')
    end
  end

  describe 'CREATE' do
    it 'should create session on form submission' do 
      expect(TutoringSession.all.count).to eq(0)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with: scheduled_datetime
      find(:link_or_button, 'Save Tutoring session').click

      expect(page).to_not have_content('Create Tutoring Session')
      expect(TutoringSession.all.count).to eq(1)
      expect(TutoringSession.first.scheduled_datetime).to eq(scheduled_datetime)
    end  

    it 'should error on no scheduled date time submission' do 
      expect(TutoringSession.all.count).to eq(0)

      visit('/tutoring_session/new')
      fill_in 'tutoring_session_scheduled_datetime', with: 
      find(:link_or_button, 'Save Tutoring session').click

      expect(page).to have_content('Create Tutoring Session')
      expect(TutoringSession.all.count).to eq(0)
    end  
  end
  describe 'SHOW' do
    it 'should be able to view session details' do 
      tsession = TutoringSession.create(:scheduled_datetime => scheduled_datetime)
      tsession.users << tutor

      visit('/tutoring_session/' + tsession.id.to_s)
      expect(page).to have_content('Session scheduled for May 26th, 2021 at 08:00 AM')
      expect(page).to have_content('Tutor User')
    end

    it 'should be able to delete session', :js => true do 
      tsession = TutoringSession.create(:scheduled_datetime => scheduled_datetime)
      tsession.users << tutor
      
      expect(TutoringSession.all.count).to eq(1)
      visit('/tutoring_session/' + tsession.id.to_s)
      accept_confirm do
        find(:link_or_button, 'delete').click
      end
      expect(TutoringSession.all.count).to eq(0)
    end
  end

  describe 'UPDATE' do
    it 'should be able to edit session details' do 
      tsession = TutoringSession.create(:scheduled_datetime => scheduled_datetime)
      tsession.users << tutor

      visit('/tutoring_session/' + tsession.id.to_s)
      find(:link_or_button, 'edit').click

      expect(page).to have_content('Edit Tutoring Session')
      fill_in 'tutoring_session_scheduled_datetime', with: (scheduled_datetime + 1.hour)
      find(:link_or_button, 'Update Tutoring session').click

      expect(TutoringSession.all.count).to eq(1)
      expect(TutoringSession.first.users.count).to eq(1)
      expect(TutoringSession.first.scheduled_datetime).to eq((scheduled_datetime + 1.hour))
    end

    it 'should error on missing scheduled_datetime edit session details' do 
      tsession = TutoringSession.create(:scheduled_datetime => scheduled_datetime)
      tsession.users << tutor

      visit('/tutoring_session/' + tsession.id.to_s)
      find(:link_or_button, 'edit').click

      expect(page).to have_content('Edit Tutoring Session')
      fill_in 'tutoring_session_scheduled_datetime', with: ""
      find(:link_or_button, 'Update Tutoring session').click
      expect(page).to have_content('Edit Tutoring Session')

      expect(TutoringSession.all.count).to eq(1)
    end
  end
end