default_run_options[:pty] = true
default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"
set :use_sudo, false

set (:deploy_to){ "/www/#{application}"}
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :user, 'shawn'
set :stage, 'production'
after "deploy:update_code", :copy_database_yml


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

  task :configure_stage do
    puts 'ignoring moonshine for this recipe'
  end 

end

namespace :shared_config do
  task :symlink do
    puts 'I prefer to copy the database.yml, not symlink.  I have mistakenly edited it or copied another file to it before which caused me some headaches'
  end
end

