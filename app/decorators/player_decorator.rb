class PlayerDecorator < LittleDecorator
  def link_to_test
    "#{Rails.application.secrets.moi_app_url}/quiz/#{record.quiz_id}/player/#{record.id}"
  end

  def score
    if record.learning_quiz
      answers = record.learning_quiz.answers || []
      rightAnswers = answers.select{|a| a['correct']  == true}.count
      "#{rightAnswers} / #{answers.count}"
    end
  end

  def time
    time_elapsed = 0
    if record.learning_quiz
      time_diff = record.learning_quiz.updated_at - record.learning_quiz.created_at
      time_elapsed = Time.at(time_diff).utc.strftime("%H :%M :%S")
    end
    time_elapsed
  end

end
