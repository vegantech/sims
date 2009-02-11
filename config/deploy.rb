default_run_options[:pty] = true
default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"



set :domain, 'sims-open.vegantech.com'
set :repository,  "git://github.com/vegantech/sims.git"
set :application, "sims-open"

desc "pilot for pilot, default is demo"
task :pilot do
  set :domain, 'simspilot.vegantech.com'
  set :application, "simspilot"
end


set :use_sudo, false
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set (:deploy_to){ "/www/#{application}"}

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, "git"

set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1


role :app, "vegantech.com"
role :web, "vegantech.com"
role :db,  "vegantech.com", :primary => true

after "deploy:update_code", :copy_database_yml, :setup_domain_constant
after "deploy:cold", :load_fixtures, :create_intervention_pdfs


namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Reset Files and data"
  task :reset_files_and_data, :roles => "app" do 
    run "cd #{deploy_to}/current && RAILS_ENV=production rake db:drop db:create db:migrate db:fixtures:load && rm -rf #{deploy_to}/current/system/*"
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
  run "cd #{deploy_to}/current && rake db:fixtures:load RAILS_ENV=production"
end

task :setup_domain_constant do
  run "cd #{release_path}/config/initializers && sed -i  -e 's/#SIMS_DOMAIN =/SIMS_DOMAIN =\"#{domain}\"/' host_info.rb "
end

desc 'Create the intervention pdf reports'
task :create_intervention_pdfs do
  run "cd #{deploy_to}/current && RAILS_ENV=production ruby script/runner DailyJobs.regenerate_intervention_reports"
end

