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
    root false
    attributes :id,
               :title,
               :neuron_can_read

    has_many :contents

    def contents
      object.approved_contents.map do |content|
        title = content.title
        lang = current_user.preferred_lang
        unless lang == ApplicationController::DEFAULT_LANGUAGE
          resp = TranslatedAttribute.where(translatable_id: content.id, name: "title").last
          title = resp ? resp.content : title
        end
        {
          id: content.id,
          neuron_id: content.neuron_id,
          media: content.content_medium.map(&:media_url),
          kind: content.kind,
          level: content.level,
          read: current_user.already_read?(content),
          learnt: current_user.already_learnt?(content),
          title: title,
          favorite: is_favorite?(content)
        }
      end
    end


    def neuron_can_read
      visible_neurons = TreeService::PublicScopeFetcher.new(@scope).neurons
      visible_neurons.map(&:id).include?(object.id)
    end

    alias_method :current_user, :scope

    def is_favorite?(content)
      ContentFavorite.where(
        user: current_user,
        content: content
      ).exists?
    end
  end
end
