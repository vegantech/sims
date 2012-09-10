server "staging.sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
set :rails_env, "staging"
set :branch, 'ruby_1.9.3'

after  :setup_domain_constant, :setup_default_url,  :setup_https_protocol, :enable_subdomains
