server "staging.sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
set :rails_env, "staging"
  set :branch, 'improved_students_index'


after  :setup_domain_constant, :setup_default_url,  :setup_https_protocol, :enable_subdomains
