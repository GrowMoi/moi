class PublicSharingController < ApplicationController
  layout false

  def show
    puts "UA!"
    puts request.user_agent
    @social_sharing = SocialSharing.friendly.find(params[:id])
  end

  private

  def facebook_app_id
    Rails.application.secrets.facebook_app_id
  end
  helper_method :facebook_app_id
end
