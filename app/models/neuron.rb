class Neuron < ActiveRecord::Base
  belongs_to :parent, class: Neuron
  #paper trail gem
  has_paper_trail

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
  end

  def to_s
    title
  end

end
