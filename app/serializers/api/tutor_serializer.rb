module Api
  class TutorSerializer < ActiveModel::Serializer
    attributes :id,
               :email,
               :name,
               :role,
               :uid,
               :provider,
               :country,
               :birthday,
               :city,
               :username
  end
end
