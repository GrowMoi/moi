class TranslatableContentVideo
  def initialize(content_video:, target_lang:)
    @content_video = content_video
    @target_lang = target_lang
  end

  def translate!
    @content_video.language = @target_lang
    @content_video.save
  end
end
