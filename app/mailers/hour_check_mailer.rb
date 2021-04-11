# frozen_string_literal: true

class HourCheckMailer < ApplicationMailer
  default from: 'noreply@tutoringscheduler.com'

  def hours_email
    @recipient = params[:email].presence || current_user.email
    @filepath = params[:filepath]
    @begin = params[:begin]
    @end = params[:end]
    attachments["Tutoring_Hours_#{@begin}_to_#{@end}.csv"] = File.read(@filepath.to_s)
    mail(to: @recipient, subject: "Tutoring Hours from #{@begin} to #{@end}")
  end
end
