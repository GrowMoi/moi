class PlayerDecorator < LittleDecorator
  def link_to_test
    "#{Rails.application.secrets.moi_app_url}/quiz/#{record.quiz_id}/player/#{record.id}"
  end

  def score
    if record.learning_quiz
      answers = record.learning_quiz.answers
      rightAnswers = answers.select{|a| a['correct']  == true}.count
      "#{rightAnswers} / #{answers.count}"
    end
  end

end
