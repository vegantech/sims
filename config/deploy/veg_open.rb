load "#{File.dirname(__FILE__)}/prohibition.rb"
load "deploy/assets"
set :application, "sims-open"
set :default_url, 'http://sims-open.vegantech.com'

server "vegantech.com", :app, :web, :db, primary: true
set :login_note, 'This is the demo.   You use names like oneschool (look to the menu at the left for more.)'
set :domain, "sims-open.vegantech.com"
set :branch, "master"
after  :setup_domain_constant, :enable_subdomains

# set :branch, 'jquery'
