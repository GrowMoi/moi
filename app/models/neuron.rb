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

  #relations
  has_many :contents, dependent: :destroy
  belongs_to :parent, class: Neuron
  has_paper_trail only: [:title, :parent_id]

  #nested
  accepts_nested_attributes_for :contents, :allow_destroy => true, reject_if: proc { |attributes| attributes['description'].blank? }

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
  end

  def to_s
    title
  end

end
