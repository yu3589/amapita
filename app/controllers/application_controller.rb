class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_path, alert: "無効なURLです"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :role ])
  end
end
