# frozen_string_literal: true

class NotificationController < ApplicationController
  def show
    notification = Notification.find(params[:id])
    notification.read_at = Time.zone.now.to_datetime
    notification.save

    if notification.notifiable_type == 'TutoringSessionUser'
      Notification.where(notifiable_type: 'TutoringSessionUser').each do |noti| 
        noti.read_at = Time.zone.now.to_datetime
        noti.save
      end
      redirect_to controller: 'tutoring_session_user', action: 'show'
      return
    end

    redirect_to '/'
  end
end
