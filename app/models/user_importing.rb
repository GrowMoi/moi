# == Schema Information
#
# Table name: user_importings
#
#  id         :integer          not null, primary key
#  users      :json             default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserImporting < ActiveRecord::Base

  validates :users, presence: true

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["username", "authorization_key", "name", "email", "authorization_key_es"]
      users = User.where(id: self.users)
      users.each do |user|
        csv << [user.username, user.authorization_key, user.name, user.email, UserAuthorizationKeys::KEYS_ES[user.authorization_key.to_sym]]
      end
    end
  end
end
