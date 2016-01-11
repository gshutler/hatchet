# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Railtie to hook Hatchet into Rails.
  #
  # Wraps the default Rails.logger, Rails.application.assets.logger, and all log
  # subscribers found in ActiveSupport::LogSubscriber.log_subscribers
  # collection.
  #
  class Railtie < Rails::Railtie

    # Expose Hatchet's configuration object to consumers through the Rails
    # config object.
    #
    self.config.hatchet = Hatchet.configuration

    # Add the Hatchet::Middleware to the middleware stack to enable nested
    # diagnostic context clearance between requests.
    #
    initializer "hatchet_railtie.insert_middleware" do |app|
      app.config.middleware.insert_before(Rails::Rack::Logger, Hatchet::Middleware)
    end

    # Wrap the default Rails.logger, Rails.application.assets.logger, and all
    # log subscribers found in ActiveSupport::LogSubscriber.log_subscribers
    # collection on initialization.
    #
    initializer 'hatchet_railtie.replace_logger' do |app|
      Railtie.wrap_rails_logger(app)
    end

    # Internal: Class method to encapsulate the replacement of the Rails logger
    # with Hatchet.
    #
    def self.wrap_rails_logger(app)
      initialize_hatchet(app, Rails.logger)
      replace_rails_loggers(app)
    end

    private

    def self.replace_rails_loggers(app)
      # Replace the Rails.logger with the application's Hatchet logger.
      #
      Rails.logger = app.logger
      app.logger.debug { 'Replaced Rails logger with Hatchet' }

      # Replace the logger of every subscriber in the
      # ActiveSupport::LogSubscriber.log_subscribers collection by extending
      # them with Hatchet.
      #
      ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
        app.logger.debug { "Replacing #{subscriber.class} logger with Hatchet" }
        subscriber.extend Hatchet
      end

      # Replace the Rails.application.assets.logger with a logger that lives
      # in a module beneath the application. This allows you to target the
      # asset logger messages directly when managing levels.
      #
      # As you can guess by the description this is probably the riskiest so
      # we do it last.
      #
      app.logger.debug { 'Replacing Rails asset logger with Hatchet' }

      wrap_asset_logging(app)
    rescue
      # If anything goes wrong along the way log it and let the application
      # continue.
      #
      Rails.logger.error { 'Failed to replace logger with Hatchet' }
      Rails.logger.error { $! }
    end

    def self.wrap_asset_logging(app)
      # Do nothing if asset pipeline not enabled
      return unless Rails.application.assets

      # Initially replace it with the application logger as it's better for
      # this to be done if the next part fails.
      #
      Rails.application.assets.logger = app.logger

      # Create the <Application>::Assets module and extend it with Hatchet so
      # that it can replace the assets logger.
      #
      assets = Module.new
      app.class.const_set 'Assets', assets
      assets.extend Hatchet
      Rails.application.assets.logger = assets.logger
    end

    def self.initialize_hatchet(app, logger)
      # Map the level of the logger so Hatchet uses the same.
      #
      current_level = logger_level(logger)

      # Add an appender that delegates to the current Rails.logger to Hatchet's
      # configuration.
      #
      Hatchet.configure do |config|
        config.level(current_level) if current_level
        config.appenders << Hatchet::LoggerAppender.new(logger: logger)
      end

      # Extend the application with Hatchet.
      #
      app.extend Hatchet
    end

    def self.logger_level(logger)
      case logger.level
      when Logger::DEBUG then :debug
      when Logger::INFO  then :info
      when Logger::WARN  then :warn
      when Logger::ERROR then :error
      when Logger::FATAL then :fatal
      else nil # If not recognized use Hatchet's default
      end
    end

  end

end
