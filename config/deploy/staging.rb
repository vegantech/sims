server "staging.sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
set :rails_env, "staging"
#set :branch, 'asset_pipeline'

after  :setup_domain_constant, :setup_default_url,  :setup_https_protocol, :enable_subdomains
