class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error

  rescue_from Exception, with: :render_resource_error

  # strong_params in decent exposure
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  # cancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, error: I18n.t("views.unauthorized")
  end

  def render_resource_error(exception)
    if Rails.env.production || Rails.env.staging
      Airbrake.notify(exception, airbrake_request_data)
      flash[:error] = exception.message
      redirect_to root_path
    end
  end

end
