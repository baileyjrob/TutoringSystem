# frozen_string_literal: true

# Manages parameters for devise
class ApplicationController < ActionController::Base
  # allows sign up to take in name and major and attach it to the user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_notifications

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name
                                                         last_name
                                                         major])
  end

  before_action :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email password password_confirmation first_name
                                               last_name major])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email password password_confirmation first_name
                                               last_name major])
  end

  def set_notifications
    @notifications = Notification.where(recipient: current_user)
                                 .unread.select('distinct on (action) *')
  end
end
