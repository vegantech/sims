ssh_options[:keys] = %w('~/.ssh/id_rsa')

set :stages, %w(staging production wip pilot2 veg_open open2 other)
set :default_stage, 'staging'
require 'capistrano/ext/multistage' rescue 'YOU NEED TO INSTALL THE capistrano-ext GEM'

set :deploy_via, :remote_cache
set :git_submodules_recursive, false
#set :git_enable_submodules, false
# default_run_options[:pty] = true
# default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"

set :git_enable_submodules, false
require 'bundler/capistrano'

set :bundle_without, [:development, :test, :cucumber]

set :login_note, 'This is the demo.   You use names like oneschool (look to the menu at the left for more.)
 <br /> The data in this demo gets reset daily.'



after "deploy:update_code", :setup_domain_constant, :overwrite_login_pilot_note, :link_file_directory, :update_new_relic_name, :link_secret,
  "deploy:clean_vendored_submodules", "link_external_student_verification_config", "link_windows_live_yml"
after "deploy:restart",  "deploy:kickstart"
after "deploy:cold", :seed, :create_intervention_pdfs, :create_file_directory, :create_secret


namespace :deploy do
  desc "Reset Files and data"
  task :reset_files_and_data, :roles => "app" do
    run "cd #{deploy_to}/current && RAILS_ENV=#{fetch(:rails_env, "production")} rake db:reset && rm -rf #{deploy_to}/current/system/*"
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

desc 'Seed the database'
task :seed do
  run "cd #{deploy_to}/current && rake db:seed RAILS_ENV=#{fetch(:rails_env, "production")}"
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


desc 'Link External Student Verification Config if it exists'
task :link_external_student_verification_config do
  run "cd #{deploy_to}; if [ -e 'external_student_location_verify.yml' ]; then ln -s #{deploy_to}/external_student_location_verify.yml #{release_path}/config; fi"
end

desc 'Link windows_live.yml'
task :link_windows_live_yml do
  run "cd #{deploy_to}; if [ -e 'windows_live.yml' ]; then ln -s #{deploy_to}/windows_live.yml #{release_path}/config; fi"
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'airbrake-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'airbrake/capistrano'

set :default_environment, self[:default_environment].merge(
'RUBY_GC_MALLOC_LIMIT'=>1000000000,
'RUBY_FREE_MIN'=>500000,
'RUBY_HEAP_MIN_SLOTS'=>800000,
'RUBY_HEAP_SLOTS_INCREMENT'=>300000,
'RUBY_HEAP_SLOTS_GROWTH_FACTOR'=>1)
