module Api
  class TreeNeuronSerializer < ActiveModel::Serializer
    root false

    ATTRIBUTES = TreeService::UserTreeFetcher::ATTRIBUTES + [
      :children,
      :state,
      :total_approved_contents,
      :learnt_contents,
      :in_desired_neuron_path,
      :title_translate
    ].freeze

    attributes *ATTRIBUTES

    def state
      if current_user.already_learnt_any?(object.contents)
        "florecida"
      else
        "descubierta"
      end
    end

    def children
      @children
    end

    def children=(new_children)
      @children = new_children
    end

    def total_approved_contents
      object.approved_contents.count
    end

    def learnt_contents
      count = 0
      object.contents.map do |content|
        if current_user.already_learnt?(content)
          count = count + 1
        end
      end
      count
    end

    def in_desired_neuron_path
      desired_neuron_id = context[:desired_neuron_path]
      return false if desired_neuron_id.blank?
      ::TreeService::RecursiveParentsIdsFetcher.new(desired_neuron_id).parents_ids.include?(object.id)
    end

    def title_translate
      lang = current_user.preferred_lang
      if lang == ApplicationController::DEFAULT_LANGUAGE
        object.title
      else
        resp = TranslatedAttribute.where(translatable_id: object.id,
                                  language: lang,
                                  translatable_type: "Neuron")
                                  .first
        resp ? resp.content : object.title
      end
    end

    alias_method :current_user, :scope
  end
end
