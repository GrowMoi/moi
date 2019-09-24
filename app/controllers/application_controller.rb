class ApplicationController < ActionController::Base
  DEFAULT_LANGUAGE = "es"

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :error

  before_action :configure_permitted_parameters, if: :devise_controller?

  # strong_params in decent exposure
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  # cancan
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path,
                status: :forbidden,
                error: I18n.t("views.unauthorized")
  end

  expose(:decorated_current_user) {
    decorate current_user
  }

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(*added_attrs) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(*added_attrs) }
  end

  def current_language
    params[:lang].presence || DEFAULT_LANGUAGE
  end
  helper_method :current_language

  def translate_attribute(resource, attribute)
    TranslateAttributeService.translate(resource, attribute, current_language)
  end
  helper_method :translate_attribute

  def show_if_translation_available?(resource, attribute)
    if current_language == DEFAULT_LANGUAGE
      true
    else
      resource.class.translated_attrs.include?(attribute)
    end
  end
  helper_method :show_if_translation_available?

  private

  def after_sign_out_path_for(resource_or_scope)
    # buster cache:
    response.headers["Cache-Control"] = "must-revalidate"
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    elsif resource.tutor? || resource.tutor_familiar?
      tutor_root_path
    else
      root_path
    end
  end
end
