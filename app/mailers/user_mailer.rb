class UserMailer < ApplicationMailer
	default from: 'moi@example.com'

  def change_permission(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("email.subject"))
  end
end
