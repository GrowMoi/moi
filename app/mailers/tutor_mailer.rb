class TutorMailer < ApplicationMailer
  default from: 'Banco del Pacífico <noreply@pacifico.com>'

  def achievement_notification(tutor, client, achievement)
    @tutor_name = if tutor.name.present? then tutor.name else tutor.username end
    @client_name = if client.name.present? then client.name else client.username end
    @achievement_name = achievement.name
    @url  = "http://miaulabdp.com"
    mail(to: tutor.email, subject: I18n.t("tutor_mailer.achievement_notification.subject"))
  end

  def payment_account(name, password, email, authorization_key)
    @tutor_name = name
    @tutor_password = password
    @authorization_key = authorization_key
    @url_dashboard = "http://backend.miaulabdp.com/tutor"
    @url_sign_in = "http://backend.miaulabdp.com/users/sign_in"
    @url_web_site = "http://miaulabdp.com"
    @url_youtube = "https://www.youtube.com/user/BancoPacificoEC"
    attachments.inline['moi_title.png'] = File.read("#{Rails.root}/app/assets/images/moi_title.png")
    attachments.inline['moicartaimg.png'] = File.read("#{Rails.root}/app/assets/images/moicartaimg.png")
    attachments.inline['footer_email_shared.png'] = File.read("#{Rails.root}/app/assets/images/footer_email_shared.png")
    attachments.inline['yt_icon.png'] = File.read("#{Rails.root}/app/assets/images/yt_icon.png")
    attachments.inline['moi_logo.png'] = File.read("#{Rails.root}/app/assets/images/moi_logo.png")
    mail(to: email, subject: I18n.t("tutor_mailer.payment_account.subject"))
  end

  def payment_add_student(name, email, total_tickets)
    @total_tickets = total_tickets
    @tutor_name = name
    @url_dashboard = "http://backend.miaulabdp.com/tutor"
    @url_sign_in = "http://backend.miaulabdp.com/users/sign_in"
    @url_web_site = "http://miaulabdp.com"
    @url_youtube = "https://www.youtube.com/user/BancoPacificoEC"
    attachments.inline['moi_title.png'] = File.read("#{Rails.root}/app/assets/images/moi_title.png")
    attachments.inline['moicartaimg.png'] = File.read("#{Rails.root}/app/assets/images/moicartaimg.png")
    attachments.inline['footer_email_shared.png'] = File.read("#{Rails.root}/app/assets/images/footer_email_shared.png")
    attachments.inline['yt_icon.png'] = File.read("#{Rails.root}/app/assets/images/yt_icon.png")
    attachments.inline['moi_logo.png'] = File.read("#{Rails.root}/app/assets/images/moi_logo.png")
    mail(to: email, subject: I18n.t("tutor_mailer.payment_account.subject"))
  end

end
