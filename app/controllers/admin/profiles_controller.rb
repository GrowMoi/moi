module Admin
  class ProfilesController < Neurons::BaseController
    before_action :add_breadcrumbs

    authorize_resource

    expose(:profile)

    private

    def breadcrumb_base
      "profile"
    end
  end
end
