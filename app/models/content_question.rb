# == Schema Information
#
# Table name: content_questions
#
#  id         :integer          not null, primary key
#  question   :string
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContentQuestion < ActiveRecord::Base
	begin :relationships
		belongs_to :content
		has_many :possible_answers 
	end
end
