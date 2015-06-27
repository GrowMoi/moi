# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :string           not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source      :string
#  media       :string
#

class Content < ActiveRecord::Base
  LEVELS = %w(1 2 3).map!(&:to_i)
  KINDS = %{
    que-es
    como-funciona
    por-que-es
    quien-cuando-donde
    videos
    enlaces
  }.split("\n").map(&:squish).map(&:to_sym).reject(&:blank?)

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  acts_as_taggable_on :keywords

  mount_uploader :media, ContentMediaUploader

  begin :relationships
    belongs_to :neuron
  end

  begin :validations
    validates :level, presence: true,
                      inclusion: {in: LEVELS}
    validates :kind, presence: true,
                     inclusion: {in: KINDS}
    validate :has_description_or_media
  end

  def kind
    read_attribute(:kind).try :to_sym
  end

  private

  def has_description_or_media
    if description.blank? && !media
      errors.add(
        :base,
        I18n.t("activerecord.errors.messages.content_has_description_or_media")
      )
    end
  end
end
