# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Class for configuring Hatchet.
  #
  class Configuration
    include LevelManager

    # Public: The Array of configured appenders.
    #
    attr_reader :appenders

    # Public: The default formatter to give to appenders that have not had their
    # own explicitly set.
    #
    # If not set before adding an appender, will be initialized with a
    # StandardFormatter.
    #
    attr_accessor :formatter

    # Internal: Creates a new configuration.
    #
    # Creates the levels Hash with a default logging level of info.
    #
    def initialize
      reset!
    end

    # Public: Resets the configuration's internal state to the defaults.
    #
    def reset!
      @levels = { nil => :info }
      @formatter = nil
      @appenders = []
    end

    # Public: Yields the configuration object to the given block to make it
    # tidier when setting multiple values against a referenced configuration.
    #
    # block - Mandatory block which receives a Configuration object that can be
    #         used to setup Hatchet.
    #
    # Once the block returns each of the configured appenders has its formatter
    # set to the default formatter if one is not already set, and its levels
    # Hash is set to the shared levels Hash if an explicit one has not been
    # provided.
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

      # Ensure a default formatter set.
      #
      @formatter ||= StandardFormatter.new

      # Ensure every appender has a formatter and a level configuration.
      #
      appenders.each do |appender|
        appender.formatter ||= @formatter
        appender.levels = @levels if appender.levels.empty?
      end
    end

  end

end

