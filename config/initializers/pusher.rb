require 'pusher'
unless Rails.env.test?
  Pusher.app_id = Rails.application.secrets.pusher_app_id
  Pusher.key = Rails.application.secrets.pusher_app_key
  Pusher.secret = Rails.application.secrets.pusher_app_secret
  Pusher.logger = Rails.logger
  Pusher.encrypted = true
end
