class AddContentQuestionToPossibleAnswer < ActiveRecord::Migration
  def change
    add_reference :possible_answers,
                  :content_question,
                  index: true
    say_with_time "WARNING: updating possible answers" do
      Content.all.each do |content|
        if content.possible_answers.count > 0
          cq = ContentQuestion.new
          cq.question = content.title
          cq.content = content
          if cq.save
            content.possible_answers.each do |p|
              p.content_question_id = cq.id
              p.save
            end
          end
        end
      end
    end
  end
end
