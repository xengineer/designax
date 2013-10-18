# Be sure to restart your server when you modify this file.

#Designax::Application.config.session_store :cookie_store, key: '_designax_session'
Designax::Application.config.session_store :active_record_store, key: '_designax_session'

Designax::Application.config.session = {
  :key      => '_designax_sid',
  :httponly => 'true'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Designax::Application.config.session_store :active_record_store
