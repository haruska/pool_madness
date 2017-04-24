# -*- encoding : utf-8 -*-

module Spec
  module Helper
    def active_admin_titleize(string)
      ActiveSupport::Inflector.titleize(string).capitalize
    end
  end
end

RSpec.configure do |config|
  config.include Spec::Helper
end
