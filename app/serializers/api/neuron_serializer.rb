# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#  is_public  :boolean          default(FALSE)
#
module Api
  class NeuronSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :can_read
    has_many :contents

    def contents
      object.approved_contents
    end

    def can_read
      visible_neurons = TreeService::PublicScopeFetcher.new(@scope).neurons
      visible_neurons.map(&:id).include?(object.id)
    end
  end
end
