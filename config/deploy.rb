set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage' rescue 'YOU NEED TO INSTALL THE capistrano-ext GEM'

# default_run_options[:pty] = true
# default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"


set :login_note, 'This is the demo.   You use names like oneschool (look to the menu at the left for more.)
 <br /> The data in this demo gets reset weekly.   Training districts are reset daily.'


desc ":wip for work in progress demo"
task :wip do
  set :login_note, 'This is a work in progress (unstable) demo.   You use names like oneschool (look to the menu at the left for more.)
<br /> The data in this demo gets reset weekly. Training districts are reset daily.'
  set :application, "sims-wip"
  set :domain, 'sims-wip.vegantech.com'
#  set :branch, 'aug-11-formatting-changes'

end

desc "pilot for pilot, default is demo"
task :pilot do
  set :domain, 'simspilot.vegantech.com'
  set :application, "simspilot"
  set :login_note, '<p>Use the username and password assigned by your district admin.  It may be the same as your SIS.  Be sure to pick your district if you see the district dropdown.  If you\'re looking for the demo, it\'s at <%=link_to "http://sims-open.vegantech.com", "http://sims-open.vegantech.com" %> '
end

desc "pilot2 for pilot on rimuhosting"
task :pilot2 do
  ENV['HOSTS']='74.50.50.62'
  role :app, "74.50.50.62"
  role :web, "74.50.50.62"
  role :db,  "74.50.50.62", :primary => true
  set :domain, 'simspilot.org'
  set :default_url, 'https://www.simspilot.org'
  set :application, "simspilot"
  set :login_note, '<p>Use the username and password assigned by your district admin.  It may be the same as your SIS.  Be sure to pick your district if you see the district dropdown.  If you\'re looking for the demo, it\'s at <%=link_to "http://sims-open.vegantech.com", "http://sims-open.vegantech.com" %> </p>'

  after  :setup_domain_constant, :setup_default_url, :change_railmail_to_smtp, :setup_https_protocol
end


desc "open2 for temp training on rimuhosting"
task :open2 do
  ENV['HOSTS']='74.50.50.62'
  role :app, "74.50.50.62"
  role :web, "74.50.50.62"
  role :db,  "74.50.50.62", :primary => true
end


after "deploy:update_code", :setup_domain_constant, :overwrite_login_pilot_note, :link_file_directory
after "deploy:cold", :load_fixtures, :create_intervention_pdfs, :create_file_directory


namespace :deploy do
  desc "Reset Files and data"
  task :reset_files_and_data, :roles => "app" do 
    run "cd #{deploy_to}/current && RAILS_ENV=#{fetch(:rails_env, "production")} rake db:drop db:create db:migrate db:fixtures:load && rm -rf #{deploy_to}/current/system/*"
    create_intervention_pdfs
  end

  task :start, :roles => "app" do
    puts "go start passenger and make sure it is configured"
  end

  task :stop, :roles=> "app" do
    puts "go stop passenger"
  end
end 

task :copy_database_yml do 
  run "cp  #{deploy_to}/database.yml.mysql #{release_path}/config/database.yml"
end

desc 'Load the fixtures from test/fixtures, this will overwrite whatever is in the db'
task :load_fixtures do
  run "cd #{deploy_to}/current && rake db:fixtures:load RAILS_ENV=#{fetch(:rails_env, "production")}"
end

task :setup_domain_constant do
  run "cd #{release_path}/config/initializers && sed -i  -e 's/#SIMS_DOMAIN =/SIMS_DOMAIN =\"#{domain}\"/' host_info.rb "
end

task :setup_https_protocol do
  run "cd #{release_path}/config/initializers && sed -i  -e 's/SIMS_PROTO=\"http\"/SIMS_PROTO =\"https\"/' host_info.rb "
end

task :setup_default_url do
  put("DEFAULT_URL= \"#{default_url}\"", "#{release_path}/config/initializers/default_url.rb", :via => :scp) 
end

task :change_railmail_to_smtp do
  run "cd #{release_path}/config/ && sed -i  -e 's/railmail/smtp/' environment.rb "
end
desc 'Create the intervention pdf reports'
task :create_intervention_pdfs do
  run "cd #{deploy_to}/current && RAILS_ENV=#{fetch(:rails_env, "production")} ruby script/runner DailyJobs.regenerate_intervention_reports"
end


desc 'create authenticated file directory' 
task :create_file_directory do
   run "mkdir #{deploy_to}/file"

end

desc 'link_file_directory'
task :link_file_directory do
  run "ln -nfs #{deploy_to}/file #{release_path}/file"
end



task :overwrite_login_pilot_note do
  put("#{login_note}", "#{release_path}/app/views/login/_demo_pilot_login_note.html.erb", :mode=>0755, :via=>:scp)

end

