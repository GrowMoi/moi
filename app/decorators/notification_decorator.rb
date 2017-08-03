class NotificationDecorator < LittleDecorator

  def build_one_video!
    if notification_videos.length === 0
      notification_videos.build
    end
  end

  def keywords
    notification_tag :div, class: "notification-keywords" do
      record.keyword_list.map do |keyword|
        notification_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end

  def media_list_group

    if decorated_medium.any?
      strong t("views.notifications.media") do
        content_tag :div,
                    class: "row" do
          decorated_medium.map do |media|
            media.list_group_item
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
      strong t("activerecord.attributes.notification.source") do
        record.source
      end
    end
  end

  def video_list_group
    decorated_videos.map do |video|
      content_tag :div,
                  class: "text-center" do
        if video.url.present?
          video.list_group_item
        end
      end
    end.join.html_safe
  end

  def strong(strong_str, &block)
    content_tag(:strong) do
      strong_str + ": "
    end + yield
  end

  private

  def decorated_medium
    @decorated_medium ||= notification_medium.map do |notification_media|
      decorate notification_media
    end
  end

  def decorated_videos
    @decorated_videos ||= notification_videos.map do |notification_video|
      decorate notification_video
    end
  end

  def source_is_uri?
    # taken from
    # http://stackoverflow.com/questions/1805761/check-if-url-is-valid-ruby#answer-1805788
    record.source =~ /\A#{URI::regexp}\z/
  end

end
