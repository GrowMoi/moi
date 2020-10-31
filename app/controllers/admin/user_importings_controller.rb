module Admin
  class UserImportingsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:user_importings) {
      UserImporting.order(created_at: :desc)
    }

    expose(:users_importing) {
      UserImporting.find(params[:id])
    }

    def index
      user_importings
    end

    def create
      list = params[:users]
      new_user_importing = UserImporting.new(
        list: list
      )
      if new_user_importing.save
        system "rake users:generate_users_from_list_names ID_IMPORT=#{new_user_importing.id} &"
        redirect_to admin_user_importings_path, notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def show
      ids_users = users_importing.users
      respond_to do |format|
        format.html
        format.json {
          render json: UsersDatatable.new(view_context, ids_users)
        }
      end
    end

    private

    def resource
      @resource ||= UserImporting.find(params[:id]).id
    end
  end
end
