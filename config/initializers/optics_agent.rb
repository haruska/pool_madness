optics_agent = OpticsAgent::Agent.new
optics_agent.configure { schema GraphqlSchema }
Rails.application.config.middleware.use optics_agent.rack_middleware
