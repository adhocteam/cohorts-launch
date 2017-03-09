# frozen_string_literal: true
module Middleware
  class HealthCheck
    def initialize(app)
      @app = app
    end

    def call(env)
      return [200, {}, []] if env['PATH_INFO'] == '/healthcheck'

      @app.call(env)
    end
  end
end
