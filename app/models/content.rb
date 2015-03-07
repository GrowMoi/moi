# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :integer          not null
#  description :text             not null
#  neuron_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Content < ActiveRecord::Base
  #relations
  belongs_to :neuron

  #validations
  validates :description, presence: true
end
