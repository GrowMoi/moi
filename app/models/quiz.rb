# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  level      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Quiz < ActiveRecord::Base
  extend Enumerize

  LEVELS = [
    'easy',
    'medium',
    'hard'
  ].freeze

  begin :enumerables
    enum unidad_medida: LEVELS
  end

  begin :validations
    validates :level,
              presence: true
    validates :level,
              inclusion: { in: LEVELS }
  end

  begin :relationships
    has_many :players,
            dependent: :destroy
  end

  begin :nested_attributes
    accepts_nested_attributes_for :players, allow_destroy: true,
                                            reject_if: ->(attributes) {
                                              attributes["name"].nil?
                                            }
  end
end
