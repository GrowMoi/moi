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

require 'rails_helper'

RSpec.describe UserEvent, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
