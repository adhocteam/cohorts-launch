# frozen_string_literal: true
require 'simplecov'
require 'devise'
require 'rspec/retry'

RSpec.configure do |config|
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end
end
