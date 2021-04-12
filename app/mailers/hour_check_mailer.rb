# frozen_string_literal: true

class HourCheckMailer < ApplicationMailer
  default from: 'noreply@tutoringscheduler.com'

  def hours_email
    recipient = params[:email].presence || current_user.email
    filepath = code_parse(params[:code])
    @begin = params[:begin]
    @end = params[:end]
    attachments["Tutoring_Hours_#{@begin}_to_#{@end}.csv"] = File.read(filepath)
    mail(to: recipient, subject: "Tutoring Hours from #{@begin} to #{@end}")
  end

  private

  def code_parse(code)
    case code.to_i
    when 0
      'public/tutoring_hours.csv'
    when 1
      'spec/helpers/tutoring_hours_spec.csv'
    when 2
      'spec/helpers/tutoring_hours_spec_2.csv'
    when 3
      'spec/helpers/tutoring_hours_spec_3.csv'
    end
  end
end
