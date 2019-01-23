class PossibleAnswerDecorator < ResourceDecorator
  def correct_label
    if correct?
      klass = "ok-circle"
      tooltip_key = "correct"
    else
      klass = "remove-circle"
      tooltip_key = "incorrect"
    end
    content_tag(
      :span,
      nil,
      class: "glyphicon glyphicon-#{klass} bs-tooltip",
      title: t("views.possible_answers.#{tooltip_key}")
    )
  end
end
