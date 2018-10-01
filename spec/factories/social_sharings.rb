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

FactoryGirl.define do
  factory :social_sharing do
    user

    titulo      "SharingTitle"
    descripcion "SharingDescription"
    uri         "SharingURI"
    imagen_url  "SharingImageURL"
  end
end
