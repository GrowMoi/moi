# == Schema Information
#
# Table name: user_events
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  event_id   :integer          not null
#  completed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  contents   :json             default([]), is an Array
#  expired    :boolean          default(FALSE)
#

class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :content_learning_events,
           dependent: :destroy
  has_many :content_reading_events,
           dependent: :destroy

  before_save :add_contents!

  private

  ##
  # add necessary contents
  # with neuron title
  def add_contents!
    contents = Content.includes(:neuron).where(id: self.event.content_ids)
    self.contents = contents.map do |content|
      {
        content_id: content.id,
        neuron: content.neuron.title
      }
    end
  end
end
