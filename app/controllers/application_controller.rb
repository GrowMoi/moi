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
  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_path,
                status: :forbidden,
                error: I18n.t("views.unauthorized")
  end

  expose(:decorated_current_user) do
    decorate current_user
  end

  private

  def after_sign_out_path_for(_resource_or_scope)
    # buster cache:
    response.headers["Cache-Control"] = "must-revalidate"
    root_path
  end
end
