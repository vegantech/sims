server "sims.widpi.managedmachine.com", :app, :web, :db, :primary => true
#set :branch, 'back_to_prototype'

set :domain, 'simspilot.org'
set :default_url, 'https://simspilot.org'

set :login_note, '<p>Use the username and password assigned by your district admin.  It may be the same as your SIS.  Be sure to pick your district if you see the district dropdown.  If you\'re looking for the demo, it\'s at <%=link_to "http://sims-open.vegantech.com", "http://sims-open.vegantech.com" %> </p>'

after  :setup_domain_constant, :setup_default_url,  :setup_https_protocol, :enable_subdomains

