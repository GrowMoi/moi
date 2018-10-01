# == Schema Information
#
# Table name: social_sharings
#
#  id           :integer          not null, primary key
#  titulo       :string           not null
#  descripcion  :string
#  uri          :string           not null
#  imagen_url   :string
#  slug         :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  image_width  :integer
#  image_height :integer
#

require 'rails_helper'

RSpec.describe SocialSharing, :type => :model do
  it "default IMG" do
    sharing = create :social_sharing, imagen_url: nil
    expect(
      sharing.reload.imagen_url
    ).to eq(SocialSharing.default_sharing_img)
  end
end
