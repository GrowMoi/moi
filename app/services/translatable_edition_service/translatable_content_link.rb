class TranslatableContentLink
  def initialize(content_link:)
    @content_link = content_link
  end

  def translate!
    @content_link.save
  end
end
