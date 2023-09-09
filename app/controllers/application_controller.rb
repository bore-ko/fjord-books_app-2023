# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:postal_code, :address, :self_introduction])
    devise_parameter_sanitizer.permit(:account_update, keys:[:postal_code, :address, :self_introduction])
  end

  def after_sign_in_path_for(resource)
    books_path
  end
end
