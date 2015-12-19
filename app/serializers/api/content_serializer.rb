# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  media       :string
#  approved    :boolean          default(FALSE)
#  title       :string
#

module Api
  class ContentSerializer < ActiveModel::Serializer
    attributes :id,
               :neuron_id,
               :media_url,
               :level,
               :kind,
               :description,
               :source,
               :title
  end
end
