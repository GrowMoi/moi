class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error

  # strong_params in decent exposure
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  # cancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, error: I18n.t("views.unauthorized")
  end
end
