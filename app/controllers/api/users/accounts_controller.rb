module Api
  module Users
    class AccountsController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      # expose(:user, attributes: :user_params)

      api :PUT,
          "/users/account",
          "Update user account"
      param :age, Integer
      param :authorization_key, String
      param :username, String
      param :name, String
      param :password, String, "if you want to update your account's password"
      param :city, String
      param :country, String
      param :school, String
      param :email, String
      param :gender, String
      param :avatar, Integer
      def update
        if user.update(user_params)
          render  nothing:true,
                  status: :accepted
        else
          render  text: current_user.errors.full_messages,
                  status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:account).permit(
          :username,
          :name,
          :birthday,
          :password,
          :city,
          :country,
          :school,
          :email,
          :age,
          :authorization_key,
          :avatar,
          :gender
        )
      end
    end
  end
end
