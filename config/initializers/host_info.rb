#SIMS_DOMAIN =  # sims-open.vegantech.com
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:session_domain => ".#{SIMS_DOMAIN}") if defined? SIMS_DOMAIN
SIMS_PROTO="http"  #change to https when we're using that.
#DEFAULT_URL = #'http://www.simspilot2.org:3000'


