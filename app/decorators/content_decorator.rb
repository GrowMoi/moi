class ContentDecorator < ResourceDecorator
  def build_one_instruction!
    unless self.content_instruction
      self.build_content_instruction
    end
  end

  def build_one_link!
    if content_links_for_current_lang.length === 0
      content_links.build(language: current_language)
    end
  end

  def build_one_video!
    if content_videos_for_current_lang.length === 0
      content_videos.build(language: current_language)
    end
  end

  def keywords
    content_tag :div, class: "content-keywords" do
      record.keyword_list.map do |keyword|
        content_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end

  def media_list_group
    if decorated_medium.any?
      strong t("views.contents.media") do
        content_tag :div,
                    class: "row" do
          decorated_medium.map do |media|
            media.list_group_item
          end.join.html_safe
        end
      end
    end
  end

  def links_list_group
    if decorated_links.any?
      content_tag :div,
                  class: "content-links" do
        strong t("views.contents.links") do
          decorated_links.map do |link|
            link.list_group_item
          end.join.html_safe
        end
      end
    end
  end

  def source
    if source_is_uri?
      link_to record.source,
              record.source,
              target: "_blank"
    elsif record.source.present?
      strong t("activerecord.attributes.content.source") do
        record.source
      end
    end
  end

  def video_list_group
    decorated_videos.map do |video|
      content_tag :div,
                  class: "text-center" do
        video.list_group_item
      end
    end.join.html_safe
  end

  def strong(strong_str, &block)
    content_tag(:strong) do
      strong_str + ": "
    end + yield
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

  def content_videos_for_current_lang
    content_videos.select do |video|
      video.language == current_language
    end
  end

  def content_links_for_current_lang
    content_links.select do |link|
      link.language == current_language
    end
  end

  def able_to_have_more_links?
    content_links_for_current_lang.length < Content::NUMBER_OF_LINKS
  end

  def able_to_have_more_videos?
    content_videos_for_current_lang.length < Content::NUMBER_OF_VIDEOS
  end

  private

  def decorated_medium
    @decorated_medium ||= content_medium.map do |content_media|
      decorate content_media
    end
  end

  def decorated_videos
    @decorated_videos ||= content_videos.with_language(current_language).map do |content_video|
      decorate content_video
    end
  end

  def decorated_links
    @decorated_links ||= content_links.with_language(current_language).map do |content_link|
      decorate content_link
    end
  end

  def source_is_uri?
    # taken from
    # http://stackoverflow.com/questions/1805761/check-if-url-is-valid-ruby#answer-1805788
    record.source =~ /\A#{URI::regexp}\z/
  end
end
