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

FactoryGirl.define do
  factory :content_task do

  end

end
