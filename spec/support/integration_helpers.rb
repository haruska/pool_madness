# -*- encoding : utf-8 -*-

module IntegrationHelpers
  def sign_in(user, scope = :user)
    login_as(user, scope: scope)
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.include IntegrationHelpers, type: :feature
end
