Airbrake.configure do |config|
  config.api_key = '7a09837280d1249c9b7c944051697717'
  config.host    = 'vegantech-errbit.herokuapp.com'
  config.port    = 443
  config.secure  = config.port == 443
  config.use_system_ssl_cert_chain = true

  #config.api_key = '7fed52e49c9cf366087d9071db425f1c'
  config.ignore_only  = []
  config.ignore_user_agent << 'Microsoft Office Protocol Discovery'
  config.development_environments << 'development_with_cache'
end
