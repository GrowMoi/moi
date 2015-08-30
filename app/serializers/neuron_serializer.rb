# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#

class NeuronSerializer < ActiveModel::Serializer
  attributes :id,
             :parent_id,
             :title,
             :deleted

  def deleted
    object.deleted?
  end
end
