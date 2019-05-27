class SuperEventMailer < ApplicationMailer
	default from: 'Moi Aprendizaje Social <noreply@growmoi.com>'

  def notify_admin(user, event)
		@user = user
    @event = event
    mail(to: @event.email_notify, subject: I18n.t("user_mailer.super_event.subject"))
  end
end
