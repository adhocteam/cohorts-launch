# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'spec_helper'
require 'shoulda/matchers'
require 'database_cleaner'
require 'sms_spec'
require 'timecop'
require 'mock_redis'
require 'faker'
require 'factory_girl_rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

SmsSpec.driver = :'twilio-ruby'

Redis.current = MockRedis.new # mocking out redis for our tests

require 'devise'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.server_port = 3001
end
Capybara::Screenshot.prune_strategy = :keep_last_run

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # # show retry status in spec process
  # config.verbose_retry = true
  # # show exception that triggers a retry if verbose_retry is set to true
  # config.display_try_failure_messages = true

  # # run retry only on features
  # config.around :each, :js do |ex|
  #   ex.run_with_retry retry: 3
  # end

  config.include Helpers
  config.include SmsSpec::Helpers
  config.include SmsSpec::Matchers
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.example_status_persistence_file_path = "#{::Rails.root}/tmp/rspec.data"

  config.include FactoryGirl::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include Rails.application.routes.url_helpers
  config.include AlertConfirmer, type: :feature

  # show retry status in spec process
  config.verbose_retry = false

  config.around :each, :js do |ex|
    ex.run_with_retry retry: ex.metadata[:retry] || 3
  end

  config.before(:each) do
    stub_wufoo
    Redis.current.flushdb
  end
end
