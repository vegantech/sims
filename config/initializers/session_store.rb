# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sims-open_session',
  :secret      => '9df9dcab8db4a1ccd72c79b014440d19d31042f8f6bcbec04c6c940c034d1cb210073b5613d0873544133aef0e5c21f197018d9a7ed23afbef31bc52b38c68ad'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
