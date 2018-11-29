require "rubyXL"

class ContentImportingWorker
  def initialize(resource)
    @resource = resource
  end

  def perform!
    begin
      @resource.update!(status: :in_progress)
      if @resource.kind == 'translate'
        puts 'Iam translatedddd'
        contents = ContentsTranslateBuilder.new(
          user: @resource.user,
          workbook: workbook
        ).contents_translate
        @resource.update!(
          status: :finished,
          imported_contents_ids: contents.map(&:id)
        )
      else
        contents = ContentsBuilder.new(
          user: @resource.user,
          workbook: workbook
        ).contents
        saved_contents = contents.select(&:save)
        saved_contents.each do |content|
          Content::ContentMediumSanitizer.sanitize!(content)
        end
        @resource.update!(
          status: :finished,
          imported_contents_ids: saved_contents.map(&:id)
        )
      end
    rescue StandardError => err
      @resource.update!(status: :error)
      raise err
    end
  end

  private

  def workbook
    RubyXL::Parser.parse(@resource.file.path)
  end
end
