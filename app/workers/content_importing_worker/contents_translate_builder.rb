class ContentImportingWorker
  class ContentsTranslateBuilder
    class ContenTranslateBuilder
      def initialize(row:, user:)
        @row = row
        @user = user
      end

      def content
        translate_title_neuron!
        if process_row?
          @content = Content.where('unaccent(TRIM(title)) ILIKE unaccent(?)', @row[3].value).first
          unless @content.nil?
            translate_content_title!
            translate_content_description!
            translate_possible_answers!
            translate_content_videos!
            translate_content_links!
            TranslatableEditionService::TranslatableContent.new(
              content: @content,
              target_lang: "en"
            ).translate!
            @content
          else
            nil
          end
        end
      end

      def process_row?
        @row && @row[3].value.present?
      end

      private

      def translate_title_neuron!
        if @row && @row[1].value.present? && @row[2].value.present?
          neuron = Neuron.where('unaccent(TRIM(title)) ILIKE unaccent(?)', @row[1].value.downcase).first
          unless neuron.nil?
            neuron.title = @row[2].value;
            TranslatableEditionService::TranslatableNeuron.new(
              neuron: neuron,
              target_lang: "en"
            ).translate!
          end
        end
      end

      def translate_content_title!
        title = (@row[4] && @row[4].value) ? @row[4].value : nil
        unless title.nil?
          @content.title = title
        end
      end

      def translate_content_description!
        description = @row[5] && @row[5].value ? @row[5].value : nil
        if description.nil?
          @content.description = description
        end
      end

      def translate_possible_answers!
        @content.possible_answers.each_with_index do |possible_answer, index|
          attr = possible_answers_attributes[index]
          if attr.nil?
            possible_answer.text = attr[:text]
            possible_answer.correct = attr[:correct]
          end
        end
      end

      def translate_content_links!
        content_links_attributes.each_with_index do |content_link, index|
          link = ContentLink.new
          link.link = content_link[:link]
          link.content_id = @content.id
          link.language = "en"
          link.save
        end
      end

      def translate_content_videos!
        content_videos_attributes.each_with_index do |content_video, index|
          if !content_video[:url].blank?
            video = ContentVideo.new
            video.url = content_video[:url]
            video.content_id = @content.id
            video.language = "en"
            video.save
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
    end

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
