# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Class for configuring Hatchet.
  #
  class Configuration
    include LevelManager

    # Public: The Array of configured appenders.
    #
    attr_accessor :appenders

    # Internal: Creates a new configuration.
    #
    # Creates the levels Hash with a default logging level of info.
    #
    def initialize
      @formatter = nil
      reset!
    end

    # Public: Returns the default formatter given to the appenders that have not
    # had their formatter explicitly set.
    #
    # If not otherwise set, will be a StandardFormatter.
    #
    def formatter
      @formatter.formatter
    end

    # Public: Sets the default formatter given to the appenders that have not
    # had their formatter explicitly set.
    #
    def formatter=(formatter)
      @formatter.formatter = formatter
    end

    # Public: Resets the configuration's internal state to the defaults.
    #
    def reset!
      @levels = { nil => :info }
      @appenders = []

      # If a DelegatingFormatter has already been set up replace its
      # formatter, otherwise create a new one.
      #
      if @formatter
        @formatter.formatter = StandardFormatter.new
      else
        @formatter = DelegatingFormatter.new(StandardFormatter.new)
      end
    end

    # Public: Yields the configuration object to the given block to make it
    # tidier when setting multiple values against a referenced configuration.
    #
    # block - Mandatory block which receives a Configuration object that can be
    #         used to setup Hatchet.
    #
    # Once the block returns each of the configured appenders has its formatter
    # set to the default formatter if they have one and one is not already set,
    # and its levels Hash is set to the shared levels Hash if an explicit one
    # has not been provided.
    #
    # Example
    #
    #   configuration.configure do |config|
    #     # Set the level to use unless overridden (defaults to :info)
    #     config.level :info
    #     # Set the level for a specific class/module and its children
    #     config.level :debug, 'Namespace::Something::Nested'
    #
    #     # Add as many appenders as you like
    #     config.appenders << Hatchet::LoggerAppender.new do |appender|
    #       # Set the logger that this is wrapping (required)
    #       appender.logger = Logger.new('log/test.log')
    #     end
    #   end
    #
    # Returns nothing.
    #
    def configure
      yield self

      # Ensure appenders is set.
      #
      @appenders ||= []

      # Ensure every appender has a formatter and a level configuration.
      #
      @appenders.each do |appender|
        appender.formatter ||= @formatter if appender.respond_to? 'formatter='
        appender.levels = @levels         if appender.levels.empty?
      end
    end

    # Internal: Removes the caching Hash of every appender so that they will all
    # be re-initialized.
    #
    # Used when a change to logging levels is made so that the caches will not
    # contain stale values.
    #
    def clear_levels_cache!
      appenders.each(&:clear_levels_cache!)
    end

  end

end

