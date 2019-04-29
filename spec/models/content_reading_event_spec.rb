# == Schema Information
#
# Table name: content_reading_events
#
#  id            :integer          not null, primary key
#  user_event_id :integer          not null
#  content_id    :integer          not null
#  read          :boolean          default(TRUE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ContentReadingEvent, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
