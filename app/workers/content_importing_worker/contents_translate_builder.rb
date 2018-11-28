class ContentImportingWorker
  class ContentsTranslateBuilder
    class ContenTranslateBuilder
      def initialize(row:, user:)
        @row = row
        @user = user
        @target_lang = 'en'
      end

      def content
        @content = Content.where(title: @row[3].value).first
        translate_content_title!
        translate_content_description!
        translate_possible_answers!
        translate_content_videos!
        translate_content_links!
        @content
        # edition_service = TranslatableEditionService.new(
        #   neuron: @neuron,
        #   params: 'en'
        # )
        # edition_service.save
      end

      private

      def translate_content_title!
        title = @row[4] && @row[4].value ? @row[4].value : nil
        if title
          @content.title = title
        end
      end

      def translate_content_description!
        description = @row[5] && @row[5].value ? @row[5].value : nil
        if description
          @content.title = description
        end
      end

      def translate_possible_answers!
        @content.possible_answers.each do |possible_answer, index|
          if possible_answers_attributes[index]
            possible_answer.text = possible_answers_attributes[index].text
            possible_answer.correct = possible_answers_attributes[index].correct
          end
        end
      end

      def translate_content_links!
        @content.content_links.each do |possible_answer, index|
          possible_answer.text = content_links_attributes[index].text
          possible_answer.correct = content_links_attributes[index].correct
        end
      end

      def translate_content_videos!
        @content.possible_answers.each do |possible_answer, index|
          if content_videos_attributes[index]
            possible_answer.text = content_videos_attributes[index].text
            possible_answer.correct = content_videos_attributes[index].correct
          end
        end
      end

      def content_links_attributes
        links = @row[10] && @row[10].value ? @row[10].value : ""
        links = links.split("\n")
        links = links.map {|link| {link: link.gsub(/\s+/, '')}}
        links
      end

      def content_videos_attributes
        [
          { url: (@row[9] && @row[9].value) }
        ]
      end

      def possible_answers_attributes
        [
          { text: (@row[6] && @row[6].value), correct: true },
          { text: (@row[7] && @row[7].value), correct: false },
          { text: (@row[8] && @row[8].value), correct: false }
        ]
      end

      def neuron
        PaperTrail.whodunnit = @user.id
        neuron = Neuron.where(title: @row[1].value).first
        neuron.title = @row[2].value;
        PaperTrail.whodunnit = nil
        neuron
      end
    end

    # def translate_attributes(attribute, value)
    #   translated_attr = get_translated_attribute_for(attribute)
    #   translated_attr.content = translated_value
    #   translated_attr.save!
    # end
    #
    # def get_translated_attribute_for(attribute_name)
    #   Content.translated_attributes.where(
    #     name: attribute_name,
    #     language: @target_lang
    #   ).first_or_initialize
    # end

    def initialize(workbook:, user:)
      @user = user
      @workbook = workbook
      @worksheet = @workbook[0]
    end

    def contents_translate
      @contents = []
      @worksheet.each_with_index do |row, row_index|
        if row && row_index != 0 # headers
          @contents << ContenTranslateBuilder.new(row: row, user: @user).content
        end
      end
      @contents.compact
    end
  end
end
