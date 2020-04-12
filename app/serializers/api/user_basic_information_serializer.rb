module Api
  class UserBasicInformationSerializer < ResourceSerializer
    root false

    attributes :id,
               :email,
               :name,
               :username,
               :image,
               :avatar

    def image
      object.image ? object.image.url : ''
    end

    def avatar
      if object.avatar && object.gender
        folder = object.gender === "M" ? "mens" : "women"
        path = "#{Rails.application.secrets.url}/avatars/#{folder}#{UserAvatars.avatars[:"#{object.avatar}"]}"
      end
    end
  end
end
