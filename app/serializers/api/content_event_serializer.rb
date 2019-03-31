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
  class ContentEventSerializer < ResourceSerializer
    root false
    attributes :id,
               :neuron_id,
               :media,
               :description,
               :source,
               :title,


    def media
      object.content_medium.map(&:media_url)
    end

    def title
      lang = current_user.preferred_lang
      if lang == ApplicationController::DEFAULT_LANGUAGE
        object.title
      else
        resp = TranslatedAttribute.where(translatable_id: object.id,
                                  language: lang,
                                  translatable_type: "Content")
                                  .first
        resp ? resp.content : object.title
      end
    end

    alias_method :current_user, :scope
  end
end
