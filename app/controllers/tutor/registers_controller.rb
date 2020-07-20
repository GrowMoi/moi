module Tutor
  class RegistersController < ::ApplicationController
    layout "tutor"
    before_action :hide_main_navbar

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.role = "tutor"
      if @user.save
        @user.send_confirmation_instructions
        redirect_to action: :success
      else
        render :new
      end
    end

    def success
    end

    private

    def user_params
      params.require(:user).permit(
        :username,
        :email,
        :password,
        :password_confirmation
      )
    end

    def hide_main_navbar
      @hide_main_navbar = true
    end
  end
end
