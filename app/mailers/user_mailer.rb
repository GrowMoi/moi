class UserMailer < ApplicationMailer
	default from: 'Banco del Pacífico <miaulabdp@gmail.com>'

  def notify_role_change(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("user_mailer.change_permission.subject"))
  end

  def shared_content(name, email, image_url, public_url)
    @user_name = name
    @public_url = public_url
    @image_url = image_url
    @profile_url = "http://aula.miaulabdp.com/#/user/"+name+"/profile"
    @url_dashboard = "http://backend.miaulabdp.com/tutor"
    @url_sign_in = "http://aula.miaulabdp.com"
    @url_web_site = "http://miaulabdp.com"
    @url_youtube = "https://www.youtube.com/user/BancoPacificoEC"
    attachments.inline['moicartaimg.png'] = File.read("#{Rails.root}/app/assets/images/moicartaimg.png")
    attachments.inline['footer_email_shared.png'] = File.read("#{Rails.root}/app/assets/images/footer_email_shared.png")
    attachments.inline['yt_icon.png'] = File.read("#{Rails.root}/app/assets/images/yt_icon.png")
    mail(to: email, subject: I18n.t("user_mailer.shared_content.subject"))
  end

  def send_email_to(email)
    @email = email
    mail(to: "miaulabdp@gmail.com", subject: "Clave Tutor")
  end
end
