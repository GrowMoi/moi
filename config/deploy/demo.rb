server 'moi-demo.shiriculapo.com', user: 'moi', roles: %w{app db web}

set :deploy_to, '/home/moi/moi-backend'

set :log_level, :info

set :stage, :demo
set :rails_env, :demo
