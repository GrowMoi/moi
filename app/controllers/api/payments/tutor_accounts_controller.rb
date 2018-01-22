module Api
  module payments
    class TutorAccountsController < BaseController

      api :POST,
          "/payments/tutor_account",
          "Create tutor account by payment method"
      param :total, Integer
      param :source, String
      param :payment_id, String
      param :name, String
      param :email, String

      def create
        user = User.new(name: params[:name], email: params[:email], rol: 'tutor')
        if user.save
          render  nothing:true,
                  status: :accepted
        else
          render  text: current_user.errors.full_messages,
                  status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:tutor_account).permit(
          :total,
          :source,
          :payment_id,
          :user_id
        )
      end
    end
  end
end
