# -*- encoding: utf-8 -*-

require_relative 'hatchet/configuration'
require_relative 'hatchet/logger'
require_relative 'hatchet/logger_appender'
require_relative 'hatchet/message'
require_relative 'hatchet/standard_formatter'
require_relative 'hatchet/version'

module Hatchet

  # Public: Returns a Logger for the object.
  #
  # The returned logger has 7 methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal
  #  * error
  #  * warn
  #  * info
  #  * debug
  #  * trace
  #
  # All the methods have the same signature. You can either provide a message as
  # a direct string, or as a block to the method (this is the recommended
  # option).
  #
  # Examples
  #
  #   logger.info "Informational message"
  #   logger.info { "Informational message #{potentially_expensive}" }
  #
  # Log messages are sent to every configured appender where they will be
  # filtered and invoked as configured.
  #
  # Returns a Logger for the object.
  def logger
    @_hatchet_logger ||= Logger.new self, Hatchet.appenders
  end

  # Public: Returns a logger for the object.
  #
  # The returned logger has 7 methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal
  #  * error
  #  * warn
  #  * info
  #  * debug
  #  * trace
  #
  # All the methods have the same signature. You can either provide a message as
  # a direct string, or as a block to the method (this is the recommended
  # option).
  #
  # Examples
  #
  #   log.info "Informational message"
  #   log.info { "Informational message #{potentially_expensive}" }
  #
  # Log messages are sent to every configured appender where they will be
  # filtered and invoked as configured.
  #
  # Returns a Logger for the object.
  alias_method :log, :logger

  def self.configure
    @@config = Configuration.new
    yield @@config
    @@config.appenders.each do |appender|
      appender.formatter ||= StandardFormatter.new
      appender.levels    ||= @@config.levels
    end
  end

  def self.appenders
    if @@config and @@config.appenders
      @@config.appenders
    else
      []
    end
  end

end

