require "translatable_edition_service/translatable_event"

class TranslatableEditionEventService
  def initialize(event:, params:)
    @event = event
    @target_lang = params[:lang]
  end

  def save
    case @target_lang
    when ApplicationController::DEFAULT_LANGUAGE
      @event.save
    when "en"
      translate_event!
      @event.reload
    end
  end

  private

  def translate_event!
    TranslatableEvent.new(
      event: @event,
      target_lang: @target_lang
    ).translate!
  end
end