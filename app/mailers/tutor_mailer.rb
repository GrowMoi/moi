class TutorMailer < ApplicationMailer
  default from: 'moi@example.com'

  def achievement_notification(tutor, client, achievement)
    @tutor = tutor
    @client = client
    @achievement = achievement
    mail(to: @tutor.email, subject: 'Contenidos completados')
  end
end
