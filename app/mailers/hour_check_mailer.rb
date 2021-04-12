# frozen_string_literal: true

class HourCheckMailer < ApplicationMailer
  default from: 'noreply@tutoringscheduler.com'

  def hours_email(begin_time, end_time, filepath, email = nil)
    recipient = email.presence || current_user.email
    attachments["Tutoring_Hours_#{begin_time}_to_#{end_time}.csv"] = File.read(filepath)
    mail(to: recipient, subject: "Tutoring Hours from #{begin_time} to #{end_time}")
  end
end
