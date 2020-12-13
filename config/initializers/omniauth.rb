OmniAuth.config.on_failure = Proc.new do |env|
  env['devise.mapping'] = Devise.mappings[:user]
  controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
  controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
  controller_klass.action(:failure).call(env)
end
