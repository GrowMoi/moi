module Tutor
  class ProfileController < BaseController

    def index
      render
    end

    def info
      render  json: {
        user: Api::UserProfileSerializer.new(
          current_user
        ),
        images: UserAuthorizationKeys.interests,
        authorization_key: current_user.authorization_key
      }
    end

    def update
      if current_user.update(tutor_params)
        render json: {
          message: I18n.t("views.tutor.profile.tutor_update_success")
        }
      else
        render json: {
          message: I18n.t("views.tutor.profile.tutor_update_error")
        },
        status: :unprocessable_entity
      end
    end

    def update_password
      unless current_user.valid_password?(permited_params[:current_password])
        return render json: {
          message: I18n.t("views.tutor.profile.current_password_invalid")
        },
        status: :unprocessable_entity
      end

      current_user.password = permited_params[:password]

      if current_user.save
        sign_in current_user, :bypass => true
        render json: {
          message: I18n.t("views.tutor.profile.password_update_success")
        },
        status: :ok
      else
        render json: {
          message: I18n.t("views.tutor.profile.unsafe_password")
        },
        status: :unprocessable_entity
      end
    end

    private

    def permited_params
      params.require(:tutor)
            .permit(:password, :current_password)
    end

    def tutor_params
      params.require(:tutor)
            .permit(:name, :username, :email, :authorization_key)
    end

  end
end
