root = "/home/macool/moi"

preload_app!

directory   root
pidfile     "#{root}/tmp/pids/puma.pid"
bind        'unix:///tmp/puma.moi.sock'
workers     2
threads     0,5
environment 'production'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
