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
#  approved    :boolean          default(FALSE)
#  title       :string
#

module Api
  class ContentSerializer < ResourceSerializer
    root false
    attributes :id,
               :neuron_id,
               :media,
               :level,
               :kind,
               :description,
               :source,
               :updated_at,
               :title,
               :read,
               :learnt,
               :links,
               :videos,
               :user_notes,
               :content_tasks,
               :neuron_can_read,
               :favorite,
               :belongs_to_event,
               :content_can_read,
               :consigna
    
    translates :title, :description, :source

    def consigna
      if object.content_instruction
        request = RequestContentValidation.where(
          user: current_user,
          content: object
        ).last
        {
          content_instruction: ContentInstructionSerializer.new(object.content_instruction),
          last_request_sent: RequestContentValidationSerializer.new(request)
        }
      end
    end

    def read
      current_user.already_read?(object)
    end

    def learnt
      current_user.already_learnt?(object)
    end

    def user_notes
      object.user_note(current_user).try :note
    end

    def media
      object.content_medium.map(&:media_url)
    end

    def links
      object.content_links
            .with_language(current_user.preferred_lang)
            .map(&:link)
    end

    def favorite
      ContentFavorite.where(
        user: current_user,
        content: object
      ).exists?
    end

    def neuron_can_read
      visible_neurons = TreeService::PublicScopeFetcher.new(@scope).neurons
      visible_neurons.map(&:id).include?(object.neuron.id)
    end

    def videos
      ActiveModel::ArraySerializer.new(
        object.content_videos.with_language(current_user.preferred_lang),
        each_serializer: ContentVideoSerializer
      )
    end

    def belongs_to_event
      belongs = false
      user_event = current_user.user_events.where(completed: false, expired: false).last

      if user_event
        ids = user_event.content_reading_events.map(&:content_id)
        content_event_was_read = ids.include? (object.id)
        unless content_event_was_read
          elm = { 'content_id'=> object.id.to_s, 'neuron'=> object.neuron.title }
          belongs = user_event.contents.include? (elm)
        end
      end
      belongs
    end

    def content_can_read
      if object.content_instruction
        RequestContentValidation.where(
          user: current_user,
          content: object,
        ).exists?
      else
        true
      end
    end

    alias_method :current_user, :scope
  end
end
