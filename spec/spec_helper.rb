require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'coveralls'
Coveralls.wear_merged!('rails')

require 'devise'
require 'factory_girl_rails'
# spec/spec_helper.rb
# require 'rspec/retry'

RSpec.configure do |config|
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Devise::TestHelpers, type: :controller

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
