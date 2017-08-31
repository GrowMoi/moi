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

  begin :relationships
    has_many :players,
            dependent: :destroy
  end

  begin :nested_attributes
    accepts_nested_attributes_for :players
  end
end
