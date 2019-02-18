# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :string
#  image        :string
#  content_ids  :text             default([]), is an Array
#  publish_days :text             default([]), is an Array
#  duration     :integer          not null
#  kind         :string
#  user_level   :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  active       :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Event, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
