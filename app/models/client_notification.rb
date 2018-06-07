# == Schema Information
#
# Table name: client_notifications
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  data_type  :string           not null
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ClientNotification < ActiveRecord::Base
  belongs_to :client,
             class_name: "User",
             foreign_key: "client_id"

  CATEGORIES = [
    'client_got_item',
    'client_test_completed',
    'client_message_opened',
    'client_recommended_contents_completed',
    'client_got_diploma'
  ].freeze

  begin :enumerables
    enum data_type: CATEGORIES
  end
end
