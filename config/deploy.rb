set :stages, %w(staging production wip pilot2 veg-open open2 other)
set :default_stage, 'staging'
require 'capistrano/ext/multistage' rescue 'YOU NEED TO INSTALL THE capistrano-ext GEM'

set :deploy_via, :remote_cache

# default_run_options[:pty] = true
# default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"


set :login_note, 'This is the demo.   You use names like oneschool (look to the menu at the left for more.)
 <br /> The data in this demo gets reset daily.'



after "deploy:update_code", :setup_domain_constant, :overwrite_login_pilot_note, :link_file_directory, :update_new_relic_name, :link_secret, "deploy:clean_vendored_submodules"
after "deploy:restart",  "deploy:kickstart"
after "deploy:cold", :load_fixtures, :create_intervention_pdfs, :create_file_directory, :create_secret


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

  task :kickstart, :roles => "app" do
    kickstart_url = fetch(:default_url) || fetch(:domain)
    system("curl -k -s -I  #{kickstart_url} -o /dev/null &")
  end

  desc 'clean out vendor directory to remove submodules that are no longer used' 
  task :clean_vendored_submodules, :roles => "app" do
    run "cd #{deploy_to}/shared/cached-copy && git clean -d -f vendor && cd #{release_path} && git clean -d -f vendor"
  end

end 

task :update_new_relic_name do
    run "cd #{release_path}/config/ && sed -i  -e 's/SIMS-open/SIMS-#{stage}/' newrelic.yml "
end

task :create_secret do
  run "cd #{deploy_to}/current && rake secret > #{deploy_to}/secret"
end

task :link_secret do
  run "ln -nfs #{deploy_to}/secret #{release_path}/config/secret"

end

task :copy_database_yml do 
  run "cp  #{deploy_to}/database.yml.mysql #{release_path}/config/database.yml"
end

desc 'Load the fixtures from test/fixtures, this will overwrite whatever is in the db'
task :load_fixtures do
  run "cd #{deploy_to}/current && rake db:fixtures:load RAILS_ENV=#{fetch(:rails_env, "production")}"
end

task :setup_domain_constant do
  puts fetch(:domain)
  run "cd #{release_path}/config/initializers && sed -i  -e 's/#SIMS_DOMAIN =/SIMS_DOMAIN =\"#{fetch(:domain)}\"/' host_info.rb "
end

task :setup_https_protocol do
  run "cd #{release_path}/config/initializers && sed -i  -e 's/SIMS_PROTO=\"http\"/SIMS_PROTO =\"https\"/' host_info.rb "
end

task :setup_default_url do
  put("DEFAULT_URL= \"#{default_url}\"", "#{release_path}/config/initializers/default_url.rb", :via => :scp) 
end

task :enable_subdomains do
  put("ENABLE_SUBDOMAINS = true", "#{release_path}/config/initializers/use_subdomains.rb", :via => :scp)
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



Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
