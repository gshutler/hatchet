# -*- encoding: utf-8 -*-

require_relative 'hatchet/level_manager'
require_relative 'hatchet/configuration'
require_relative 'hatchet/hatchet_logger'
require_relative 'hatchet/logger_appender'
require_relative 'hatchet/message'
require_relative 'hatchet/standard_formatter'
require_relative 'hatchet/version'

# Public: Hatchet is a library for providing logging facilities whose levels are
# configurable to the class and module level.
#
# It also provides the facility to have several appenders added to from a single
# log call with each appender capable of being configured to log at different
# levels.
#
# Hatchet provides no logging implementations of its own. Instead it delegates
# to the standard Logger within the reference LoggerAppender implementation.
#
module Hatchet

  # Public: Returns a HatchetLogger for the object.
  #
  # The logger has 5 logging methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal
  #  * error
  #  * warn
  #  * info
  #  * debug
  #
  # All these methods have the same signature. You can either provide a message
  # as a direct string, or as a block to the method is lazily evaluated (this is
  # the recommended option).
  #
  # Examples
  #
  #   logger.info "Informational message"
  #   logger.info { "Informational message #{potentially_expensive}" }
  #
  # Log messages are sent to each appender where they will be filtered and
  # invoked as configured.
  #
  # The logger also has 5 inspection methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal?
  #  * error?
  #  * warn?
  #  * info?
  #  * debug?
  #
  # All these methods take no arguments and return true if any of the loggers'
  # appenders will log a message at that level for the current context,
  # otherwise they will return false.
  #
  # Returns a HatchetLogger for the object.
  #
  def logger
    @_hatchet_logger ||= HatchetLogger.new self, Hatchet.appenders
  end

  # Public: Returns a HatchetLogger for the object.
  #
  # The logger has 5 logging methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal
  #  * error
  #  * warn
  #  * info
  #  * debug
  #
  # All these methods have the same signature. You can either provide a message
  # as a direct string, or as a block to the method is lazily evaluated (this is
  # the recommended option).
  #
  # Examples
  #
  #   log.info "Informational message"
  #   log.info { "Informational message #{potentially_expensive}" }
  #
  # Log messages are sent to each appender where they will be filtered and
  # invoked as configured.
  #
  # The logger also has 5 inspection methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal?
  #  * error?
  #  * warn?
  #  * info?
  #  * debug?
  #
  # All these methods take no arguments and return true if any of the loggers'
  # appenders will log a message at that level for the current context,
  # otherwise they will return false.
  #
  # Returns a HatchetLogger for the object.
  #
  alias_method :log, :logger

  # Public: Method for configuring Hatchet.
  #
  # block - Mandatory block which receives a Configuration object that can be
  #         used to setup Hatchet.
  #
  # Once the block returns each of the configured appenders has its formatter
  # set as a StandardFormatter if one is not already set, and its levels Hash is
  # set to the shared levels Hash if an explicit one has not been provided.
  #
  # Example
  #
  #   Hatchet.configure do |config|
  #     # Set the level to use unless overridden (defaults to :info)
  #     config.level :info
  #     # Set the level for a specific class/module and its children (can be a
  #     # string)
  #     config.level :debug, Namespace::Something::Nested
  #
  #     # Add as many appenders as you like, Hatchet comes with one that formats
  #     # the standard logger in the TTCC style of log4j.
  #     config.appenders << Hatchet::LoggerAppender.new do |appender|
  #       # Set the logger that this is wrapping (required)
  #       appender.logger = Logger.new('log/test.log')
  #     end
  #   end
  #
  # Returns nothing.
  def self.configure
    @@config = Configuration.new
    yield @@config
    default_formatter = StandardFormatter.new
    @@config.appenders.each do |appender|
      appender.formatter ||= default_formatter
      appender.levels = @@config.levels if appender.levels.empty?
    end
  end

  # Public: Callback method for when Hatchet is registered as a Sinatra helper.
  #
  # Example
  #
  #   register Hatchet
  #
  # Returns nothing.
  def self.registered(app)
    app.helpers Hatchet
  end

  # Internal: Returns the Array of configured appenders.
  #
  def self.appenders
    if @@config and @@config.appenders
      @@config.appenders
    else
      []
    end
  end

end

