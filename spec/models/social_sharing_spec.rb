require 'rails_helper'

RSpec.describe SocialSharing, :type => :model do
  it "default IMG" do
    sharing = create :social_sharing, imagen_url: nil
    expect(
      sharing.reload.imagen_url
    ).to eq(SocialSharing::DEFAULT_SHARING_IMG)
  end
end
