class SearchEngine < ActiveRecord::Base
  scope :active, ->{ where(active: true) }

  begin :validations
    validates :name, presence: true
    validates :slug, presence: true,
                     uniqueness: true
    validates :gcse_id, presence: true,
                        uniqueness: true
  end
end
