class TranslatableContentVideo
  def initialize(content_video:)
    @content_video = content_video
  end

  def translate!
    @content_video.save
  end
end
