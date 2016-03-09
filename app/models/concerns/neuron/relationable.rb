class Neuron < ActiveRecord::Base
  module Relationable
    RELATIONSHIP_MAPPING = {
      contents: ->{ contents },
      content_links: ->{ contents.map(&:content_links).flatten },
      content_medium: ->{ contents.map(&:content_medium).flatten },
      content_videos: ->{ contents.map(&:content_videos).flatten }
    }
    RELATIONSHIPS = RELATIONSHIP_MAPPING.keys.freeze

    def relationships_changed?
      RELATIONSHIPS.any? do |relationship|
        send("#{relationship}_any?", changed?: true)
      end
    end

    RELATIONSHIPS.each do |relationship|
      ##
      # if any of the contents matches the conditions
      #
      # @param opts [Hash] conditions to match
      # @example contents_any?({kind: kind})
      define_method "#{relationship}_any?" do |opts|
        relationship_scope = RELATIONSHIP_MAPPING[relationship]
        relationship_scope.call.any? do |item|
          opts.all? do |key, val|
            item.send(key).eql?(val)
          end
        end
      end
    end
  end
end
