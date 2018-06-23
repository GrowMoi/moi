# == Schema Information
#
# Table name: translated_attributes
#
#  id                :integer          not null, primary key
#  translatable_id   :integer          not null
#  translatable_type :string           not null
#  name              :string           not null
#  content           :text
#  language          :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class TranslatedAttribute < ActiveRecord::Base
  belongs_to :translatable, polymorphic: true

  validates :name, :language, presence: true
end
