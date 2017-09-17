class PlayerDecorator < LittleDecorator
  def link_to_test
    "#{Rails.application.secrets.moi_app_url}/quiz/#{record.quiz_id}/player/#{record.id}"
  end
end
