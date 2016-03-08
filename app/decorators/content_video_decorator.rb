require "uri"
require "cgi"

class ContentVideoDecorator < LittleDecorator
  SUPPORTED_PARTIES = %w(
    youtube
  ).freeze

  def list_group_item
    embedded
  end

  def embedded
    content_tag(
      :iframe,
      nil,
      src: rendered_url,
      width: 560,
      height: 315,
      frameborder: 0,
      allowfullscreen: :allowfullscreen
    )
  end

  private

  def url
    @url ||=
      begin
        @uri = URI(record.url)
        record.url.sub("#{@uri.scheme}:", "")
      rescue URI::InvalidURIError
        record.url
      end
  end

  def rendered_url
    supported_party = SUPPORTED_PARTIES.detect do |party|
      url.include?(party)
    end
    if supported_party.present?
      send("render_#{supported_party}") || url
    else
      url
    end
  end

  def render_youtube
    if uri_params.present? && uri_params["v"]
      "//www.youtube.com/embed/#{uri_params["v"].first}"
    end
  end

  def uri_params
    @uri_params ||= CGI::parse(@uri.query) if @uri.query.present?
  end
end
