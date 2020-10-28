module Admin
  class UserImportingsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    # expose(:user_importing, attributes: :user_params)
    expose(:user_importings)
    expose(:users_created) {
      users = UserImporting.find(params[:id])
      User.where(id: users.users)
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
        redirect_to admin_user_importings_path, notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def show
      users_created
    end

    private

    def resource
      @resource ||= UserImporting.find(params[:id]).id
    end
  end
end
