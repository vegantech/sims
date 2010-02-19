require "#{File.dirname(__FILE__)}/prohibition.rb"
default_run_options[:pty] = true
default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"
set :use_sudo, false

set (:deploy_to){ "/www/#{application}"}
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :user, 'shawn'

after "deploy:update_code", :copy_database_yml, :setup_domain_constant, :overwrite_login_pilot_note, :link_file_directory


namespace :deploy do
 desc "Restart Application"
 task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
 end
end

namespace :moonshine do
  task :configure do
    puts 'ignoring moonshine for this recipe'

  end
  task :apply do
    puts 'ignoring moonshine for this recipe'
  end
end

namespace :shared_config do
  task :symlink do
    puts 'I prefer to copy the database.yml, not symlink.  I have mistakenly edited it or copied another file to it before which caused me some headaches'
  end
end
server "vegantech.com", :app, :web, :db, :primary => true

  set :login_note, 'This is a work in progress (unstable) demo.   You use names like oneschool (look to the menu at the left for more.)
<br /> The data in this demo gets reset weekly. Training districts are reset daily.'
  set :application, "sims-wip"
  set :domain, 'sims-wip.vegantech.com'
#  set :branch, 'aug-11-formatting-changes'



