if Rails.env.production?
  HireFire::Resource.configure do |config|
    config.dyno(:all_worker) do
      HireFire::Macro::Sidekiq.queue
    end

    config.dyno(:elimination) do
      HireFire::Macro::Sidekiq.queue(:elimination)
    end

    config.dyno(:fast) do
      HireFire::Macro::Sidekiq.queue(:default, :mailers, :scores)
    end
  end
end
