server "sims.widpi.managedmachine.com", :app, :web, :db, :primary => true

set :domain, 'sims.widpi.managedmachine.com'
set :default_url, 'https://sims.widpi.managedmachine.com'

after  :setup_domain_constant, :setup_default_url, :change_railmail_to_smtp, :setup_https_protocol, :enable_subdomains

