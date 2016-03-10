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
  class ContentSerializer < ActiveModel::Serializer
    attributes :id,
               :neuron_id,
               :media,
               :level,
               :kind,
               :description,
               :source,
               :title,
               :learnt,
               :links,
               :videos,
               :user_notes

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
      object.content_links.map(&:link)
    end

    def videos
      object.content_videos.map(&:url)
    end

    alias_method :current_user, :scope
  end
end
