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
  class ContentLigthSerializer < ResourceSerializer
    root false
    attributes :id,
               :neuron_id,
               :media,
               :level,
               :kind,
               :read,
               :learnt,
               :favorite,
               :belongs_to_event,
               :content_can_read,
               :title
  

    translates :title, :description, :source

    def read
      current_user.already_read?(object)
    end

    def learnt
      current_user.already_learnt?(object)
    end

    def media
      object.content_medium.map(&:media_url)
    end

    def favorite
      ContentFavorite.where(
        user: current_user,
        content: object
      ).exists?
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
