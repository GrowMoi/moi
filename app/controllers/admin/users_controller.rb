module Admin
  class UsersController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:user, attributes: :user_params)
    expose(:users)
    expose(:roles) {
      User::Roles::ROLES
    }
    expose(:decorated_user) {
      decorate user
    }
    expose(:product_add_client) {
      product_key = Rails.application.secrets.add_client_to_tutor_key
      product = Product.find_by_key(product_key)
    }
    expose(:tickets_bought) {
      Payment.where(user: user, code_item: product_add_client.code).sum(:quantity)
    }
    expose(:tickets_spend) {
      user.tutor_requests_sent.accepted.count
    }
    expose(:tickets_availables) {
      total = tickets_bought - tickets_spend
    }

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: UsersDatatable.new(view_context)
        }
      end
    end

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
      allowed = [:name, :email, :role, :username, :authorization_key]
      if params[:user][:password].present?
        allowed += [:password, :password_confirmation]
      end
      allowed
    end

    def resource
      @resource ||= user
    end
  end
end
