# == Schema Information
#
# Table name: level_quizzes
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LevelQuiz < ActiveRecord::Base

  begin :validations
    validates :name, presence: true, uniqueness: true
  end

  begin :relationships
    has_many :content_level_quizzes,
             dependent: :destroy
  end
end
