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
               :neuron_can_read,
               :contents

    def contents
      ActiveModel::ArraySerializer.new(
        object.approved_contents,
        each_serializer: Api::ContentLigthSerializer,
        scope: current_user
      )
    end


    def neuron_can_read
      visible_neurons = TreeService::PublicScopeFetcher.new(@scope).neurons
      visible_neurons.map(&:id).include?(object.id)
    end

    def belongs_to_event?(content)
      belongs = false
      user_event = current_user.user_events.where(completed: false, expired: false).last

      if user_event
        ids = user_event.content_reading_events.map(&:content_id)
        content_event_was_read = ids.include? (content.id)
        unless content_event_was_read
          elm = { 'content_id'=> content.id.to_s, 'neuron'=> content.neuron.title }
          belongs = user_event.contents.include? (elm)
        end
      end
      belongs
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
