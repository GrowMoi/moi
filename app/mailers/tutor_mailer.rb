class TutorMailer < ApplicationMailer
  default from: 'Moi Aprendizaje Social <noreply@growmoi.com>'

  def achievement_notification(tutor, client, achievement)
    @tutor_name = if tutor.name.present? then tutor.name else tutor.username end
    @client_name = if client.name.present? then client.name else client.username end
    @achievement_name = achievement.name
    @url  = "http://www.growmoi.com"
    mail(to: tutor.email, subject: I18n.t("tutor_mailer.achievement_notification.subject"))
  end
end
