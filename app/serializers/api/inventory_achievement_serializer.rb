module Api
  class InventoryAchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :number,
        :description,
        :active,
        :image,
        :inactive_image,
        :is_available,
        :rewards,
        :requirement

    def name
      object.name
    end

    def number
      object.number
    end

    def description
      object.description
    end

    def image
      object.image ? object.image.url : ''
    end

    def inactive_image
      object.inactive_image ? object.inactive_image.url : ''
    end

    def active
      user_achievements[object.id] ? !!user_achievements[object.id][:active] : false
    end

    def is_available
      !!user_achievements[object.id]
    end

    def requirement
      "pending add migration"
    end

    def rewards
      case object.number
      when 1
        { 
          video: 'videos/vineta_1.mp4' 
        }
      when 2
        {
          theme: 'moi_amarillo'
        }
      when 3
        {
          theme: 'moi_rojo'
        }
      when 4
        {
          theme: 'moi_azul'
        }
      when 5
        {
          theme: 'moi_verde'
        }
      when 6
        {
          video: 'videos/vineta_4.mp4'
        }
      when 7
        {
          video: 'videos/vineta_3.mp4'
        }
      when 8
        {
          theme: 'moi_violeta'
        }
      when 9
        {
          video: 'videos/vineta_2.mp4'
        }
      when 10
        {
          runFunction: 'openModal'
        }
      else
        {}
      end
    end

    alias_method :user_achievements, :scope
  end
end
