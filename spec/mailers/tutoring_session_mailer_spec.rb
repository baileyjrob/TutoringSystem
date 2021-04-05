# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TutoringSessionMailer, type: :mailer do
  let!(:tutor) do
    User.create(
      first_name: 'Tutor',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'tutor@tamu.edu'
    )
  end

  let!(:student) do
    User.create(
      first_name: 'Student1',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'student@tamu.edu'
    )
  end

  let!(:tsession) do
    TutoringSession.create(scheduled_datetime: '26 May 2021 08:00:00 +0000'.to_datetime,
                           tutor_id: tutor.id)
  end

  describe 'pending link' do
    let(:mail) do
      described_class.with(
        to: tutor,
        student: student
      ).link_pending_email
    end

    it 'renders the headers' do
      expect(mail.subject).to eq("New tutoring application from #{student.full_name}")
      expect(mail.to).to eq([tutor.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('You have a pending'\
                                            " application from #{student.full_name}")
    end
  end

  describe 'action link' do
    let(:mail) do
      described_class.with(
        to: student,
        tutor: tutor,
        tsession: tsession,
        link_action: 'confirmed',
        message: 'Message Here'
      ).link_action_email
    end

    let(:tsession_date) do
      "#{tsession.scheduled_datetime.to_date.to_formatted_s(:long_ordinal)}"\
      " at #{tsession.scheduled_datetime.strftime('%I:%M %p')}"
    end
    let(:subject_string) do
      "[CONFIRMED] Update on your tutoring session application for #{tsession_date}"
    end

    it 'renders the headers' do
      expect(mail.subject).to eq(subject_string)
      expect(mail.to).to eq([student.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('Your application to the tutoring'\
                                           " session scheduled for #{tsession_date}")
    end
  end
end
