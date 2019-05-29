class EventAchievementDecorator < LittleDecorator

  IMAGE_EXTENSIONS = %w(jpg jpeg gif png).freeze

  def link_for_form
    if record.image?
      link_to record.image_url,
              class: "",
              target: "_blank" do
        render(include_filename: true, img_path: record.image_url)
      end
    end
  end

  def link_for_form_inactive
    if record.inactive_image?
      link_to record.inactive_image_url,
              class: "",
              target: "_blank" do
        render(include_filename: true, img_path: record.inactive_image_url)
      end
    end
  end

  def video_preview
    if record.video_message.present?
      regex = /youtube.com.*(?:\/|v=)([^&$]+)/
      video_code = record.video_message.match(regex)[1]
      content_tag(
        :iframe,
        nil,
        src: "//www.youtube.com/embed/#{video_code}",
        width: 560,
        height: 315,
        frameborder: 0,
        allowfullscreen: :allowfullscreen
      )
    end
  end

  private

  ##
  # @param options [Hash]
  # @option options [Boolean] :include_filename
  #   defaults to false
  def render(options = {})
    options = {
      include_filename: !rendereable?
    }.merge(options)

    rendered = case file_extension
               when *IMAGE_EXTENSIONS
                 image_tag(record.image_url)
               else
                 glyphicon
               end
    rendered += file.filename if options[:include_filename]
    rendered
  end

  def glyphicon
    content_tag :span,
                nil,
                class: "glyphicon glyphicon-paperclip"
  end

  def rendereable?
    [
      IMAGE_EXTENSIONS
    ].flatten.include?(file_extension)
  end

  def file_extension
    @file_extension ||= file.filename.split(".").last
  end

  def file
    @file ||= record.image.file
  end

end
