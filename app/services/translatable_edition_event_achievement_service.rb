require "translatable_edition_service/translatable_event_achievement"

class TranslatableEditionEventAchievementService
  def initialize(event_achievement:, params:)
    @event_achievement = event_achievement
    @target_lang = params[:lang]
  end

  def save
    case @target_lang
    when ApplicationController::DEFAULT_LANGUAGE
      @event_achievement.save
    when "en"
      translate_event_achievement!
      @event_achievement.reload
    end
  end

  private

  def translate_event_achievement!
    TranslatableEventAchievement.new(
      event_achievement: @event_achievement,
      target_lang: @target_lang
    ).translate!
  end
end