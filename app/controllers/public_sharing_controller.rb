class PublicSharingController < ApplicationController
  layout false

  def show
    @social_sharing = SocialSharing.friendly.find(params[:id])
  end
end
