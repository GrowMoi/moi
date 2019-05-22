class SuperEventUserMailer < ApplicationMailer
	default from: 'Moi Aprendizaje Social <noreply@growmoi.com>'

  def send_message(user, event)
		@user = user
    @event = event
    mail(to: @user.email, subject: I18n.t("user_mailer.super_event.subject"))
  end
end
