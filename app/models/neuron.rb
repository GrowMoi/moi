# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Neuron < ActiveRecord::Base
  belongs_to :parent, class: Neuron
  #paper trail gem
  has_paper_trail only: [:title, :parent_id]

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
  end

  def to_s
    title
  end

end
