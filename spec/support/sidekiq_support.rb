require "sidekiq/testing"

Sidekiq::Testing.fake! # fake is the default mode
Sidekiq::Testing.inline!
Sidekiq::Testing.disable!

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
