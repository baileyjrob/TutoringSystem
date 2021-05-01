# frozen_string_literal: true

require 'rails_helper'
RSpec.describe TutoringSessionUserController, type: :feature do
  let!(:tutor) do
    User.create(
      first_name: 'Tutor',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'tutor@tamu.edu'
    )
  end

  let!(:student1) do
    User.create(
      first_name: 'Student1',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'student@tamu.edu'
    )
  end

  let!(:student2) do
    User.create(
      first_name: 'Student2',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'student2@tamu.edu'
    )
  end

  let!(:tsession) do
    TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime,
                           tutor_id: tutor.id)
  end

  let!(:link1) do
    TutoringSessionUser.create(tutoring_session: tsession, user: student1, link_status: 'pending',
                               session_course: 'math 101')
  end

  after do
    link1.link_status = 'pending'
    link1.save
    Timecop.return
  end

  before do
    TutoringSessionUser.create(tutoring_session: tsession, user: student2, link_status: 'pending',
                               session_course: 'csce 101')
    visit('/users/sign_in/')
    fill_in 'user_email', with: 'tutor@tamu.edu'
    fill_in 'user_password', with: 'T3st!!a'

    find(:link_or_button, 'Log in').click
  end

  describe 'SHOW' do
    it 'lists pending links' do
      visit('/tutoring_session/pending/')
      expect(page).to have_content(student1.email)
      expect(page).to have_content(student2.email)
    end

    it 'does not list confirmed links' do
      link1.link_status = 'confirmed'
      link1.save

      visit('/tutoring_session/pending/')

      expect(page).not_to have_content(student1.email)
    end

    it 'does not list denied links' do
      link1.link_status = 'denied'
      link1.save

      visit('/tutoring_session/pending/')

      expect(page).not_to have_content(student1.email)
    end
  end

  describe 'UPDATE' do
    it 'confirms on click', js: true do
      visit('/tutoring_session/pending/')
      find(".pending-link[data-target='#{link1.id}'] button.action[data-action='Confirm']").click
      fill_in 'message-text', with: 'TEST'
      find(:link_or_button, 'Send email').click
      expect(page).not_to have_content(student1.email)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).not_to eq(nil)
      expect(mail.to.to_s).to include(student1.email)
    end

    it 'denies on click', js: true do
      visit('/tutoring_session/pending/')
      find(".pending-link[data-target='#{link1.id}'] button.action[data-action='Deny']").click
      fill_in 'message-text', with: 'TEST'
      find(:link_or_button, 'Send email').click
      expect(page).not_to have_content(student1.email)

      mail = ActionMailer::Base.deliveries.last
      expect(mail).not_to eq(nil)
      expect(mail.to.to_s).to include(student1.email)
    end
  end
end
