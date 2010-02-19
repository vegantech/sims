default_run_options[:pty] = true
default_environment["PATH"]="/opt/bin/:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:/home/shawn/bin"
set :use_sudo, false

  ENV['HOSTS']='74.50.50.62'
  role :app, "74.50.50.62"
  role :web, "74.50.50.62"
  role :db,  "74.50.50.62", :primary => true
  set :domain, 'simspilot.org'
  set :default_url, 'https://www.simspilot.org'
  set :application, "simspilot"
  set :login_note, '<p>Use the username and password assigned by your district admin.  It may be the same as your SIS.  Be sure to pick your district if you see the district dropdown.  If you\'re looking for the demo, it\'s at <%=link_to "http://sims-open.vegantech.com", "http://sims-open.vegantech.com" %> </p>'





set (:deploy_to){ "/www/#{application}"}
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
after "deploy:update_code", :copy_database_yml, :setup_domain_constant, :overwrite_login_pilot_note, :link_file_directory

after  :setup_domain_constant, :setup_default_url, :change_railmail_to_smtp, :setup_https_protocol




namespace :deploy do
 desc "Restart Application"
 task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
 end
end



server "simspilot.org", :app, :web, :db, :primary => true


