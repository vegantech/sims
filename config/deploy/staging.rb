set :default_url, 'https://staging.sims.widpi.managedmachine.com'
server "staging.sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
set :domain, 'staging.sims.widpi.managedmachine.com'
set :rails_env, "staging"
