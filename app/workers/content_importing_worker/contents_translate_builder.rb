require 'pry'
class ContentImportingWorker
  class ContentsTranslateBuilder
    class ContenTranslateBuilder
      def initialize(row:, user:)
        @row = row
        @user = user
        @target_lang = 'en'
      end

      def content
        if process_row?
          @content = Content.where(title: @row[3].value).first
          translate_content_title!
          translate_content_description!
          translate_possible_answers!
          translate_content_videos!
          TranslatableEditionService::TranslatableContent.new(
            content: @content,
            target_lang: @target_lang
          ).translate!
          @content
        end
      end

      def process_row?
        @row && @row[3].value.present?
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
          @content.description = description
        end
      end

      def translate_possible_answers!
        @content.possible_answers.each_with_index do |possible_answer, index|
          attr = possible_answers_attributes[index]
          if attr
            possible_answer.text = attr[:text]
            possible_answer.correct = attr[:correct]
          end
        end
      end

      def translate_content_links!
        @content.content_links.each_with_index do |content_link, index|
          attr = content_links_attributes[index]
          if attr
            content_link.link = attr[:link]
          end
        end
      end

      def translate_content_videos!
        @content.content_videos.each_with_index do |content_video, index|
          attr = content_videos_attributes[index]
          if attr
            content_video.url = attr[:url]
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
