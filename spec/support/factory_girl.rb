# -*- encoding : utf-8 -*-

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation

    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end
