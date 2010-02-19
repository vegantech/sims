load "#{File.dirname(__FILE__)}/prohibition.rb"
set :application, "sims-open"

server "vegantech.com", :app, :web, :db, :primary => true
  set :login_note, 'This is a work in progress (unstable) demo.   You use names like oneschool (look to the menu at the left for more.)
<br /> The data in this demo gets reset weekly. Training districts are reset daily.'
  set :domain, 'sims-wip.vegantech.com'
#  set :branch, 'aug-11-formatting-changes'



