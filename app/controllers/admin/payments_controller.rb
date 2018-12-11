require 'pry'
module Admin
  class PaymentsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:payment, attributes: :payment_params)
    expose(:user) {
      user = User.find(params[:user_id])
    }
    expose(:decorated_user) {
      decorate user
    }

    expose(:payment_tutor) {
      Payment.new
    }

    def index
    end

    def create
      if payment.save
        redirect_to admin_users_path, notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def update
      if payment.save
        redirect_to admin_users_path, notice: I18n.t("views.users.updated")
      else
        render :edit
      end
    end

    def tutor_assign_tickets
      # decorated_user
      product_key = Rails.application.secrets.add_client_to_tutor_key
      product = Product.find_by_key(product_key)

      if user
        payment.user = user
        payment.product = product
        payment.code_item = product_key
        payment.payment_id = "MOI-3271312"
        payment.source = "MOI-ADMIN"
      end
    end

    private

    def payment_params
      params.require(:payment).permit(
        :total,
        :source,
        :payment_id,
        :code_item,
        :user_id,
        :product_id,
        :quantity
      )
    end

    def resource
      @resource ||= user
    end
  end
end
