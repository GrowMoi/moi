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
  class NeuronPublicSerializer < ActiveModel::Serializer
    root false
    attributes :id,
               :title,
               :read_only

    has_many :contents

    def contents
      object.approved_contents.map do |content|
        {
          id: content.id,
          neuron_id: content.neuron_id,
          media: content.content_medium.map(&:media_url),
          kind: content.kind,
          level: content.level,
          title: content.title
        }
      end
    end

    def read_only
      true
    end
  end
end
