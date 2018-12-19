module Admin
  class PaymentsController < AdminController::Base
    include Breadcrumbs

    before_action :authenticate_user!, :add_breadcrumbs

    authorize_resource

    expose(:payment, attributes: :payment_params)

    expose(:user) {
      if params[:user_id]
        User.find(params[:user_id])
      else
        Payment.find(params[:id]).user
      end
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

    expose(:all_payments_tickets) {
      Payment.where(product_id: product_add_client.id)
    }

    def index
    end

    def show
    end

    def create
      if payment.save
        redirect_to admin_users_path, notice: I18n.t("views.payments.tickets.created")
      else
        render :tutor_assign_tickets
      end
    end

    def update
      if payment.save
        redirect_to admin_users_path, notice: I18n.t("views.payments.tickets.updated")
      else
        render :edit
      end
    end

    def tutor_assign_tickets
      if user
        payment.user = user
        payment.product = product_add_client
        payment.code_item = product_add_client.code
        payment.payment_id = "MOI-PAYMENT"
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
