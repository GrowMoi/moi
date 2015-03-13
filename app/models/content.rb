# == Schema Information
#
# Table name: contents
#
#  id          :integer          not null, primary key
#  level       :integer          not null
#  kind        :integer          not null
#  description :text             not null
#  neuron_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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

  #relations
  belongs_to :neuron

  #callbacks
  before_save :touch_parent!

  begin :validations
    validates :description, presence: true
    validates :level, presence: true,
                      inclusion: {in: LEVELS}
    validates :kind, presence: true,
                     inclusion: {in: KINDS}
  end

  def kind
    read_attribute(:kind).try :to_sym
  end

  def touch_parent!
    self.neuron.content_id = self.id
    self.neuron.level = self.level
    self.neuron.kind = self.kind
    self.neuron.description = self.description
    self.neuron.neuron_id = self.neuron_id
    self.neuron.touch_with_version
  end
end
