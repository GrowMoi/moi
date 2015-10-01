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
    if record.source =~ (/\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i)
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
    @spellchecked_description ||= spellcheck_description
  rescue RuntimeError => e
    if e.message == "Aspell command not found"
      # aspell is not present. gracefully fallback
      # to original description
      return spellcheck_error
    else
      raise e
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
    if record.description.present?
      aspell_error = content_tag(
        :div,
        I18n.t("views.contents.aspell_not_present"),
        class: "small text-danger"
      )
      (record.description + aspell_error).html_safe
    end
  end

  def spellcheck_description
    Spellchecker.check(
      record.description.to_s,
      I18n.locale.to_s
    ).map do |w|
      if w[:correct]
        w[:original]
      else
        suggestions = w[:suggestions].first(3).join(" | ")
        content_tag(:span,
                    w[:original] + " ",
                    class: "bs-tooltip text-danger",
                    title: suggestions)
      end
    end.join(" ").html_safe
  end
end
