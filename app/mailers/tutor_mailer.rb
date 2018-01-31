class TutorMailer < ApplicationMailer
  default from: 'Moi Aprendizaje Social <noreply@growmoi.com>'

  def achievement_notification(tutor, client, achievement)
    @tutor_name = if tutor.name.present? then tutor.name else tutor.username end
    @client_name = if client.name.present? then client.name else client.username end
    @achievement_name = achievement.name
    @url  = "http://www.growmoi.com"
    mail(to: tutor.email, subject: I18n.t("tutor_mailer.achievement_notification.subject"))
  end

  def payment_account(name, password, email)
    @tutor_name = name
    @tutor_password = password
    @url_dashboard = "http://moi-backend.growmoi.com/tutor"
    @url_sign_in = "http://moi-backend.growmoi.com/users/sign_in"
    mail(to: email, subject: I18n.t("tutor_mailer.payment_account.subject"))
  end
end
