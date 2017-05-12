# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  neuron_id   :integer          not null
#  title       :string
#

module Api
  class BasicContentSerializer < ActiveModel::Serializer
    attributes :id,
               :neuron_id,
               :media,
               :title

    def media
      object.content_medium.map(&:media_url)
    end

    alias_method :current_user, :scope
  end
end
