# == Schema Information
#
# Table name: possible_answers
#
#  id                  :integer          not null, primary key
#  content_id          :integer          not null
#  text                :string           not null
#  correct             :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  content_question_id :integer
#

class PossibleAnswer < ActiveRecord::Base
  include TranslatableAttrs
  include SpellcheckAnalysable

  SPELLCHECK_ATTRIBUTES = %w( text ).freeze

  translates :text

  begin :relationships
    belongs_to :content
    belongs_to :content_question
  end

  begin :validations
    validates :text, presence: true
  end
end
