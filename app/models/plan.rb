# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Plan < ActiveRecord::Base
  begin :validations
    validates :code, uniqueness: true
    validates :name, presence: true,
                     uniqueness: true
  end

  begin :callbacks
    before_create :set_code!
  end

  private

  def set_code!
    code = (0...6).map { (65 + rand(26)).chr }.join
    self.code = code
  end
end
