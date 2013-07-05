module Hatchet

  # Public: Middleware for making sure the nested diagnostic context is cleared
  # between requests.
  #
  class Middleware
    include Hatchet

    # Public: Creates a new instance of the middleware, wrapping the given
    # application.
    #
    # app - The application to wrap.
    #
    def initialize(app)
      @app = app
    end

    # Public: Calls the wrapped application with the given environment, ensuring
    # the nested diagnostic context is cleared afterwards.
    #
    # env - The enviroment Hash for the request.
    #
    # Returns the status, headers, body Array returned by the wrapped
    # application.
    #
    def call(env)
      @app.call(env)
    ensure
      log.flush!
      log.ndc.clear!
    end

  end

end
