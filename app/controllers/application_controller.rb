class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def configure_permitted_parameters
    params[:user][:type] = nil if params[:user].present? && params[:user][:type].blank?
    devise_parameter_sanitizer.for(:sign_up) << :type
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
