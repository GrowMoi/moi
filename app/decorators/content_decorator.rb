class ContentDecorator < LittleDecorator
  def keywords
    content_tag :div, class: "content-keywords" do
      record.keyword_list.map do |keyword|
        content_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end

  def media
    if decorated_medium.any?
      decorated_medium.map do |media|
        media.link
      end.join.html_safe
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

  def decorated_medium
    @decorated_medium ||= content_medium.map do |content_media|
      decorate content_media
    end
  end

  def source_is_uri?
    # taken from
    # http://stackoverflow.com/questions/1805761/check-if-url-is-valid-ruby#answer-1805788
    record.source =~ /\A#{URI::regexp}\z/
  end

  def spellcheck_analysis
    @spellcheck_analysis ||= SpellcheckDecorator.new(
      record,
      self
    )
  end
end
