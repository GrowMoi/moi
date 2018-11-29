require "translatable_edition_service/generic_translatable_resource"
require "translatable_edition_service/translatable_possible_answer"
require "translatable_edition_service/translatable_content_video"
require "translatable_edition_service/translatable_content_link"

class TranslatableContent < GenericTranslatableResource
  def initialize(content:, target_lang:)
    @resource = content
    @target_lang = target_lang
  end

  def translate!
    translate_possible_answers!
    translate_content_videos!
    translate_content_links!
    translate_attributes!
  end

  private

  def translate_content_links!
    @resource.content_links.each do |content_link|
      TranslatableContentLink.new(
        content_link: content_link,
        target_lang: @target_lang
      ).translate!
    end
  end

  def translate_content_videos!
    @resource.content_videos.each do |content_video|
      TranslatableContentVideo.new(
        content_video: content_video,
        target_lang: @target_lang
      ).translate!
    end
  end

  def translate_possible_answers!
    @resource.possible_answers.each do |possible_answer|
      TranslatablePossibleAnswer.new(
        possible_answer: possible_answer,
        target_lang: @target_lang
      ).translate!
    end
  end
end
