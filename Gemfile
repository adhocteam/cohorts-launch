source 'https://rubygems.org'
ruby '2.3.1'
gem 'rails', '~> 4.2.0'
gem 'pg'
gem 'redis'
gem 'mail', '2.6.3'
gem 'ransack'

# Use puma as the app server
gem 'puma'

# Use HAML for views
gem 'haml-rails'

# Use Semantic UI for UI
gem 'less-rails-semantic_ui'
gem 'autoprefixer-rails'

# Use old Sprockets to avoid deprecation warnings
gem "sprockets", '3.6.3'

gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# AWS
gem 'aws-sdk'

# pagniate with will_paginate: https://github.com/mislav/will_paginate
gem 'will_paginate'
gem 'will_paginate_semantic_ui'

# include health_check, for system monitoring
gem 'health_check'

# use holder for placeholder images
gem 'holder_rails'

# use devise for auth/identity
gem 'devise', '~>4.2.0'

# use gibbon for easy Mailchimp API access
gem 'gibbon', '~> 2.2.3'

# use twilio-ruby for twilio
gem 'twilio-ruby'

# use Wuparty for wufoo
gem 'wuparty'

# Use gsm_encoder to help text messages send correctly
gem 'gsm_encoder'

# use Delayed Job to queue messages
gem 'delayed_job_active_record'
gem 'daemons'

# for generating unique tokens for Person
gem 'has_secure_token'

# phone number validation
gem 'phony_rails'

# zip code validation
gem 'validates_zipcode'

# in place editing
gem 'best_in_place', '~> 3.0.1'

# validation for new persons on the public page.
gem 'jquery-validation-rails'

# make ical events and feeds
# gem 'icalendar'

# cron jobs for backups and sending reminders
gem 'whenever', require: false

# handling emoji!
gem 'emoji'

# auditing.
gem 'paper_trail'
gem 'paper_trail-globalid'

gem 'fast_blank' # blank? rewritten in c
#gem 'faster_path' # soon! path, rewitted in rust. requires rust compiler

# storing money with money-rails
gem 'money-rails'

# masked inputs
gem 'maskedinput-rails'

# Need a non-digested asset for Wufoo CSS
gem "non-stupid-digest-assets"

# Allow composite primary keys for join tables
gem 'composite_primary_keys'

group :development do
  # this whole group makes finding performance issues much friendlier
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof' # ruby 2.1+ only
  gem 'memory_profiler'
  gem 'ruby-prof'

  # n+1 killer.
  gem 'bullet'

  # what attributes does this model actually have?
  gem 'annotate'

  # a console in your tests, to find out what's actually happening
  gem 'pry-rails'

  # a console in your browser, when you want to interrogate views.
  gem 'web-console'

  # silences logging of requests for assets
  gem 'quiet_assets'

  # for debugging in dev
  gem 'byebug'

  # for generating favicons
  gem 'rails_real_favicon'
end

# Use rails 12factor for staging and production
group :staging, :production do
  gem 'rails_12factor'
end

group :production do
  gem 'newrelic_rpm'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  # mock tests w/mocha
  gem 'mocha', require: false

  gem 'sqlite3', platform: [:ruby, :mswin, :mingw]

  # for JRuby
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'memory_test_fix' # in memory DB, for the speedy

  # generate fake data w/faker: http://rubydoc.info/github/stympy/faker/master/frames
  gem 'faker'
  gem 'rubocop', require: false
  gem 'simplecov', require: false
  # screenshots when capybara fails
  gem 'capybara-screenshot'

  # retry poltergeist specs. they are finicky
  gem 'rspec-retry'

  # calendaring tests will almost always break on saturdays.
  gem 'timecop'

  # in memory redis for testing only
  gem 'mock_redis'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'capybara-email'
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'shoulda-matchers', '~> 3.1.1', require: false
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'sms-spec'
end
