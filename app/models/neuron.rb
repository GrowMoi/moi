class Neuron < ActiveRecord::Base
  belongs_to :parent, class: Neuron

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
  end

  def to_s
    title
  end

  def to_node
    {
      name: self.title,
      children: [ Neuron.where(parent_id: self.id).map do |n| n.to_node end]
    }
  end
end
