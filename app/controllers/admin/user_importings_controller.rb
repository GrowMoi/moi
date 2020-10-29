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
    expose(:users_created) {
      User.where(id: users_importing.users)
    }

    def index
      user_importings
    end

    def create
      list = params[:users]
      split_users = params[:users].split("\r\n").map {|name| name.strip}
      split_users = split_users.reject(&:empty?)
      users_ids = UserService.new(split_users).run!
      new_user_importing = UserImporting.new(
        users: users_ids
      )
      if new_user_importing.save
        redirect_to admin_user_importing_path(new_user_importing), notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def show
      respond_to do |format|
        format.html
        format.csv { send_data users_importing.to_csv, filename: "users-#{users_importing.created_at}.csv" }
      end
    end

    private

    def resource
      @resource ||= UserImporting.find(params[:id]).id
    end
  end
end
