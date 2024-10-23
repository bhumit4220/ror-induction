class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to request.referrer || root_path, alert: exception.message
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.user?
      resource.update(online: true)
      books_path 
    else
      report_books_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
