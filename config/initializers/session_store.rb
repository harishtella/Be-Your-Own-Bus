# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_byob_session',
  :secret      => 'ca2be97206d065474a1616b8f11dc77025d1cffd89a202b30a937e477092c84f845c8d7b1ae351883dcde57d33a50bb19c816b5eca588806faa07f85e557f6b8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
