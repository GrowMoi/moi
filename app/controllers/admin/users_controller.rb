module Admin
  class UsersController < AdminController::Base
    respond_to(:html, :json)
    expose(:users) do
      respond_to do |format|
        format.html
        format.json { render json: UsersDatatable.new(view_context) }
      end
    end
    expose(:user, attributes: :user_params)
    expose(:roles) {
      User::Roles::ROLES
    }

    def create
      if user.save
        redirect_to admin_users_path, notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def update
      if user.save
        redirect_to admin_users_path, notice: I18n.t("views.users.updated")
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [:name, :email, :role]
      if params[:user][:password].present?
        allowed += [:password, :password_confirmation]
      end
      allowed
    end
  end
end
