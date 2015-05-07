class ContentDecorator < LittleDecorator
  def keywords
    content_tag :div, class: "content-keywords" do
      record.keyword_list.map do |keyword|
        content_tag :span, keyword, class: "label label-info"
      end.join.html_safe
    end
  end

  def source
    if record.source.present?
      link_to record.source,
              record.source,
              target: "_blank"
    end
  end
end
