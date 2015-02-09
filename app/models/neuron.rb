class Neuron < ActiveRecord::Base
  belongs_to :parent, class: Neuron

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
  end
end
