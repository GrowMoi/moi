module Api
  class TreeNeuronSerializer < ActiveModel::Serializer
    root false

    ATTRIBUTES = TreeService::UserTreeFetcher::ATTRIBUTES + [
      :children,
      :state,
      :total_approved_contents,
      :learnt_contents
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

    alias_method :current_user, :scope
  end
end
