class TranslatableContentLink
  def initialize(content_link:, target_lang:)
    @content_link = content_link
    @target_lang = target_lang
  end

  def translate!
    @content_link.language = @target_lang
    @content_link.save
  end
end
