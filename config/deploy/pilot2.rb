load "#{File.dirname(__FILE__)}/prohibition.rb"
  ENV['HOSTS']='74.50.50.62'
  role :app, "74.50.50.62"
  role :web, "74.50.50.62"
  role :db,  "74.50.50.62", :primary => true
  set :domain, 'simspilot.org'
  set :default_url, 'https://www.simspilot.org'
  set :application, "simspilot"
  set :login_note, '<p>Use the username and password assigned by your district admin.  It may be the same as your SIS.  Be sure to pick your district if you see the district dropdown.  If you\'re looking for the demo, it\'s at <%=link_to "http://sims-open.vegantech.com", "http://sims-open.vegantech.com" %> </p>'



  after  :setup_domain_constant, :setup_default_url, :change_railmail_to_smtp, :setup_https_protocol


