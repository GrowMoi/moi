class UserChat < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :sender_id,
            :receiver_id,
            :message,
            presence: true
end
