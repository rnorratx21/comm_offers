# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_community-offers_session',
  :secret      => 'ed5990a7d73b2a459849ba43f08e7aab5f8da5e298c3d9c92d69b00a5bb29cc6c4100d6f0e2ea4811f73b8f24e94a9867db977ad1d711fddd02d2a5615c59fa1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
