# == Schema Information
#
# Table name: content_approved_by_tutors
#
#  id         :integer          not null, primary key
#  tutor_id   :integer          not null
#  user_id    :integer          not null
#  content_id :integer          not null
#  approved   :boolean          default(TRUE), not null
#  message    :string
#  media      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :content_approved_by_tutor do
    
  end

end
