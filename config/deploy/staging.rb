set :default_url, 'https://www.staging.simspilot.org'
server "staging.sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
set :domain, 'staging.simspilot.org'
set :rails_env, "staging"
set :branch, "moonshine_upgrade"

after  :setup_domain_constant, :setup_default_url,  :setup_https_protocol, :enable_subdomains
