class ContentDecorator < LittleDecorator
  IMAGE_EXTENSIONS = %w(jpg jpeg gif png).freeze

  def keywords
    content_tag :div, class: "content-keywords" do
      record.keyword_list.map do |keyword|
        content_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end

  def media_for_form
    if record.media?
      filename = media_file.filename if rendereable?
      link_to record.media_url,
              class: "content-media",
              target: "_blank" do
        render_media + filename
      end
    end
  end

  def media
    if record.media?
      link_to record.media_url,
              class: "content-media",
              target: "_blank" do
        render_media
      end
    end
  end

  def source
    if source_is_uri?
      link_to record.source,
              record.source,
              target: "_blank"
    else
      content_tag(:strong) do
        t("activerecord.attributes.content.source") + ": "
      end + record.source
    end
  end

  def can_be_approved?
    can?(:approve, record) && record.persisted?
  end

  def toggle_approved
    render "admin/neurons/contents/toggle_approved",
           decorator: self,
           icons: {
             "true" => "glyphicon-ok-circle",
             "false" => "glyphicon-ban-circle"
           }
  end

  def spellchecked(name)
    spellcheck_analysis.spellchecked(name.to_s)
  end

  def approved_to_s
    approved_options(record.approved?)
  end

  def approved_options(key=nil)
    @approved_options ||= {
      "true" => "approved",
      "false" => "unapproved"
    }
    return @approved_options if key.nil?
    @approved_options[key.to_s]
  end

  def decorated_possible_answers
    possible_answers.select(&:persisted?)
                    .map do |possible_answer|
                      decorate possible_answer
                    end
  end

  private

  def source_is_uri?
    # taken from
    # http://stackoverflow.com/questions/1805761/check-if-url-is-valid-ruby#answer-1805788
    record.source =~ /\A#{URI::regexp}\z/
  end

  def media_file
    @media_file ||= record.media.file
  end

  def media_file_extension
    @media_file_extension ||= media_file.filename.split(".").last
  end

  def rendereable?
    [
      IMAGE_EXTENSIONS
    ].flatten.include?(media_file_extension)
  end

  def render_media
    case media_file_extension
    when *IMAGE_EXTENSIONS
      image_tag record.media_url
    else
      glyphicon = content_tag :span,
                              nil,
                              class: "glyphicon glyphicon-paperclip"
      glyphicon + media_file.filename
    end
  end

  def spellcheck_analysis
    @spellcheck_analysis ||= SpellcheckDecorator.new(
      record,
      self
    )
  end
end
