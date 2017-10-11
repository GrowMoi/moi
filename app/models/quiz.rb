# == Schema Information
#
# Table name: quizzes
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  level_quiz_id :integer          not null
#

class Quiz < ActiveRecord::Base

  begin :relationships
    belongs_to :level_quiz
    has_many :players,
            dependent: :destroy
  end

  begin :validations
    validates :level_quiz_id, presence: true
  end

  begin :nested_attributes
    accepts_nested_attributes_for :players, allow_destroy: true,
                                            reject_if: ->(attributes) {
                                              attributes["name"].nil?
                                            }
  end
end
