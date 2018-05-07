module Api
  class PaymentsController < BaseController

    api :POST,
        "/payments/tutor_account",
        "Create tutor account by payment method"
    param :total, Integer
    param :source, String
    param :payment_id, String
    param :code_item, String
    param :name, String
    param :email, String

    def tutor_account
      tutor_isValid = !params[:name].blank? && !params[:email].blank?
      payment_isValid = !params[:payment_id].blank? && !params[:code_item].blank?
      isValidCode = validate_code(params[:code_item])
      if (tutor_isValid && payment_isValid && isValidCode)
        user = User.new(name: params[:name],
                        email: params[:email],
                        username: generate_username,
                        password: generate_password,
                        role: "tutor")
        if user.save
          payment = Payment.new(payment_params)
          payment.user = user
          payment.save
          TutorMailer.payment_account(user.name, user.password, user.email).deliver_now
          render nothing: true,
                 status: :accepted
        else
          render text: user.errors.full_messages,
                 status: :unprocessable_entity,
                 errors: user.errors.full_messages
        end
      else
        render text: "invalid payment",
               status: :unprocessable_entity
      end
    end

    private

    def add_client
      user = User.find_by_email(params[:email])
      if user

      end
    end

    def payment_params
      params.require(:payment).permit(
        :total,
        :source,
        :payment_id,
        :code_item,
        :user_id
      )
    end

    def generate_username
      username = "moi-" + params[:email].parameterize + rand(1000).to_s
    end

    def generate_password
      password = Devise.friendly_token.first(10)
    end

    def validate_code(code)
      plan = Product.where(code: code, category:'plan').first
      !plan.nil?
    end
  end
end
