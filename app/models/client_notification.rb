# == Schema Information
#
# Table name: client_notifications
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  data_type  :integer          not null
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted    :boolean          default(FALSE)
#  opened     :boolean          default(FALSE)
#

class ClientNotification < ActiveRecord::Base
  belongs_to :client,
             class_name: "User",
             foreign_key: "client_id"

  CATEGORIES = [
    'client_got_item',
    'client_test_completed',
    'client_message_open',
    'client_recommended_contents_completed',
    'client_got_diploma',
    'client_need_validation_content',
    'client_completed_super_event',
    'client_got_validation_content',
  ].freeze

  begin :enumerables
    enum data_type: CATEGORIES
  end

  def send_pusher_notification(channel, data_type)
    unless Rails.env.test?
      user_channel_general = channel
      begin
        Pusher.trigger(user_channel_general, data_type, self.data)
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      else
        puts "PUSHER: Message sent successfully!"
        puts "PUSHER: #{self.data}"
      end
    end
  end
end
