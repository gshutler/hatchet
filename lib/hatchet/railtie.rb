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
    Hatchet.configure do |config|
      self.config.hatchet = config
    end

    # Wrap the default Rails.logger, Rails.application.assets.logger, and all
    # log subscribers found in ActiveSupport::LogSubscriber.log_subscribers
    # collection on initialization.
    #
    initializer 'hatchet_railtie.replace_logger' do |app|

      # Keep a handle to the original logger.
      #
      logger = Rails.logger

      # Add an appender that delegates to the current Rails.logger to Hatchet's
      # configuration.
      #
      Hatchet.configure do |config|
        config.appenders << Hatchet::LoggerAppender.new(logger: logger)
      end

      # Extend the application with Hatchet.
      #
      app.extend Hatchet

      begin
        # Replace the Rails.logger with the application's Hatchet logger.
        #
        logger.debug 'Replacing Rails logger with Hatchet'
        Rails.logger = app.logger

        # Replace the logger of every subscriber in the
        # ActiveSupport::LogSubscriber.log_subscribers collection by extending
        #
        ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
          logger.debug "Replacing #{subscriber.class} logger with Hatchet"
          subscriber.extend Hatchet
        end

        # Replace the Rails.application.assets.logger with a logger that lives
        # in a module beneath the application. This allows you to target the
        # asset logger messages directly when managing levels.
        #
        # As you can guess by the description this is probably the riskiest so
        # we do it last.
        #
        logger.debug 'Replacing Rails asset logger with Hatchet'

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

      rescue
        # If anything goes wrong along the way log it and let the application
        # continue.
        #
        logger.error 'Failed to replace logger with Hatchet'
        logger.error $!
      end
    end
  end

end
