set :default_url, 'https://staging.sims.widpi.managedmachine.com'
server "staging.sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
set :domain, 'staging.sims.widpi.managedmachine.com'
set :rails_env, "staging"

task :setup_domain_constant do
    run "cd #{release_path}/config/initializers && sed -i  -e 's/#SIMS_DOMAIN =/SIMS_DOMAIN =\"staging.sims.widpi.managedmachine.com\"/' host_info.rb "
    run "cd #{release_path}/config/initializers && sed -i  -e 's/www//' subdomain_fu.rb "
end

