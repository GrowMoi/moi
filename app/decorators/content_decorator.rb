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
      record.source
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

  def description_spellchecked
    if spellchecked["description"].present?
      spellchecked["description"].html_safe
    elsif record.description.present?
      content_tag(
        :span,
        record.description
      ) + spellcheck_error.html_safe
    end
  end

  def title_spellchecked
    if spellchecked["title"].present?
      spellchecked["title"].html_safe
    elsif record.title.present?
      content_tag(
        :span,
        record.title
      ) + spellcheck_error.html_safe
    end
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

  private

  def source_is_uri?
    # taken from
    # http://stackoverflow.com/questions/1805761/check-if-url-is-valid-ruby#answer-1805788
    record.source =~ /\A#{URI::regexp}\z/
  end

  def media_file
    @media_file ||= record.media.file
  end

  def rendereable?
    [
      IMAGE_EXTENSIONS
    ].flatten.include?(media_file.extension)
  end

  def render_media
    case media_file.extension
    when *IMAGE_EXTENSIONS
      image_tag record.media_url
    else
      glyphicon = content_tag :span,
                              nil,
                              class: "glyphicon glyphicon-paperclip"
      glyphicon + media_file.filename
    end
  end

  def spellcheck_error
    content_tag(
      :span,
      nil,
      class: "glyphicon glyphicon-exclamation-sign bs-tooltip spellcheck-error",
      title: I18n.t("views.contents.aspell_not_present")
    )
  end

  def spellchecked
    @spellchecked ||= spellcheck_analyses.inject({}) do |memo, analysis|
      if analysis.success?
        memo[analysis.attr_name] = spellchecked_attr(analysis)
      end
      memo
    end
  end

  def spellchecked_attr(analysis)
    analysis.words.inject(
      record.send(analysis.attr_name)
    ) do |text, word|
      text.gsub(
        word["original"],
        suggestions_for(word)
      )
    end
  end

  def suggestions_for(word)
    content_tag(:span,
                word["original"],
                class: "bs-tooltip text-danger",
                title: word["suggestions"].join(" | "))
  end
end
