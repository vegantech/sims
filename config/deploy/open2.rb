load "#{File.dirname(__FILE__)}/prohibition.rb"

  set :login_note, 'This is a work in progress (unstable) demo.   You use names like oneschool (look to the menu at the left for more.)
<br /> The data in this demo gets reset weekly. Training districts are reset daily.'
  set :application, "sims-open"
  set :domain, 'simspilot.org'
  set :branch, 'rails2.3.3.1'


  ENV['HOSTS']='74.50.50.62'
  role :app, "74.50.50.62"
  role :web, "74.50.50.62"
  role :db,  "74.50.50.62", :primary => true


