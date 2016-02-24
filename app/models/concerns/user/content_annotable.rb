class User < ActiveRecord::Base
  module ContentAnnotable
    ##
    # @param content [Content] content who
    #   holds the user notes
    # @param note [String] notes to store
    #   for given content
    def annotate_content(content, note)
      content_note_for(content).update!(
        note: note
      )
    end

    ##
    # @param content [Content] content to
    #   look for in the notes
    # @return [ContentNote] annotations for
    #   the user and the content. returns a
    #   new instance if none existent
    def content_note_for(content)
      content_notes.where(
        content: content
      ).first_or_initialize
    end
  end
end
