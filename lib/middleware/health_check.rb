module Middleware
  class HealthCheck
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"] == "/healthcheck"
        return [200, {}, []]
      end

      @app.call(env)
    end
  end
end
