class RemoveReferencePossibleAnswerFromContent < ActiveRecord::Migration
  def change
    remove_reference :possible_answers, :content
  end
end
