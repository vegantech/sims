load "#{File.dirname(__FILE__)}/prohibition.rb"
set :application, "sims-open"
set :email, 'SIMS <change_this@simspilot.org>'

server "vegantech.com", :app, :web, :db, primary: true
set :login_note, 'This is the demo.   You use names like oneschool (look to the menu at the left for more.)'
set :domain, "sims-open.vegantech.com"
#  set :branch, 'aug-11-formatting-changes'
after  :setup_domain_constant, :enable_subdomains, :update_email

task :update_new_relic_name do
    run "cd #{release_path}/config/ && sed -i  -e 's/SIMS-open/SIMS-other#{stage}/' newrelic.yml "
end

task :update_email do 
  run "cd #{release_path}/config/initializers/ && sed -i -e 's/^DEFAULT_EMAIL=.*/DEFAULT_EMAIL=\"#{email}\"/' mail.rb"  
end





