# frozen_string_literal: true

class HourCheckMailer < ApplicationMailer
  default from: 'noreply@tutoringscheduler.com'

  def hours_email
      @recipient = current_user.email
      @filepath = params[:filepath]
      @begin = params[:begin]
      @end = params[:end]
      attachments["Tutoring_Hours_#{@begin.to_s}-#{@end.to_s}.csv"] = File.read("#{@filepath}")
      mail(to: @recipient, subject: "Tutoring Hours from #{@begin} to #{@end}")
  end
  # def link_pending_email
  #   @to = params[:to]
  #   @student = params[:student]
  #   @url = "#{root_url}/tutoring_session/pending"
  #   mail(to: @to.email, subject: "New tutoring application from #{@student.full_name}")
  # end

  # def link_action_email
  #   link_action_params
  #   subject_string = "[#{@link_action.upcase}] Update on your tutoring session"\
  #   " application for #{@tsession_date}"
  #   mail(to: @to.email, subject: subject_string)
  # end

  # private

  # def link_action_params
  #   @to = params[:to]
  #   @tutor = params[:student]
  #   @tsession = params[:tsession]
  #   @link_action = params[:link_action]
  #   @message = params[:message]
  #   @tsession_date = "#{@tsession.scheduled_datetime.to_date.to_formatted_s(:long_ordinal)}"\
  #   " at #{@tsession.scheduled_datetime.strftime('%I:%M %p')}"
  # end
end
