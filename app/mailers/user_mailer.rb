class UserMailer < ApplicationMailer
	default from: 'notifications@example.com'

  def change_permission(user)
    @user = user
    mail(to: @user.email, subject: 'Change your permission')
  end
end
