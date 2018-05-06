class SocialSharing < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  DEFAULT_SHARING_IMG = "http://moi.growmoi.com/images/moi-logo.png"

  belongs_to :user

  delegate :username, to: :user, prefix: true

  validates :titulo,
            :descripcion,
            :uri,
            :user_id,
            presence: true

  before_save :ensure_imagen_url
  before_save :set_image_size

  def slug_candidates
    [
      [:user_username, :titulo]
    ]
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  def ensure_imagen_url
    if imagen_url.blank?
      self.imagen_url = DEFAULT_SHARING_IMG
    end
  end

  def set_image_size
    sizes = FastImage.size(imagen_url)
    if sizes.present?
      self.image_width = sizes[0]
      self.image_height = sizes[1]
    end
  end
end
