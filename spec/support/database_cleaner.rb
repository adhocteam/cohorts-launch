# frozen_string_literal: true
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.around(:each) do |example|
    DatabaseCleaner.strategy =
      if example.metadata[:js]
        :truncation
      else
        :transaction
      end
    DatabaseCleaner.start

    example.run

    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
