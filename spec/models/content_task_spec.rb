# == Schema Information
#
# Table name: content_tasks
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted    :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe ContentTask, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
