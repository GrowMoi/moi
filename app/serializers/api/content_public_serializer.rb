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
  class ContentPublicSerializer < ActiveModel::Serializer
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
               :read_only

    def read
      false
    end

    def learnt
      false
    end

    def user_notes
      nil
    end

    def media
      object.content_medium.map(&:media_url)
    end

    def links
      object.content_links.map(&:link)
    end

    def favorite
      false
    end

    def neuron_can_read
      false
    end

    def read_only
      true
    end

    def videos
      ActiveModel::ArraySerializer.new(
        object.content_videos,
        each_serializer: ContentVideoSerializer
      )
    end

  end
end
