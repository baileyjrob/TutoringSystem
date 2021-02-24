class ApplicationController < ActionController::Base
#allows sign up to take in name and major and attach it to the user
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name,
                                                       :last_name,
                                                       :major])
  end

  before_action :update_sanitized_params, if: :devise_controller?

     def update_sanitized_params
       devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :first_name, :last_name, :major])
       devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :first_name, :last_name, :major])
     end
end
