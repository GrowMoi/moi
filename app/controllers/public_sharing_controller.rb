class PublicSharingController < ApplicationController
  layout false

  def show
    @social_sharing = SocialSharing.friendly.find(params[:id])
    unless agent_is_facebook?
      redirect_to(@social_sharing.uri)
    end
  end

  private

  def agent_is_facebook?
    request.user_agent =~ Regexp.new("facebookexternalhit/1.1")
  end

  def facebook_app_id
    Rails.application.secrets.facebook_app_id
  end
  helper_method :facebook_app_id
end
