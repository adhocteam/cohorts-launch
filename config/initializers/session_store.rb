# Be sure to restart your server when you modify this file.

Cohorts::Application.config.session_store :cookie_store, key: '_cohorts_session', secure: (Rails.env.production?)
