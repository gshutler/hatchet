require_relative 'hatchet/configuration'
require_relative 'hatchet/logger'
require_relative 'hatchet/logger_appender'
require_relative 'hatchet/standard_formatter'
require_relative 'hatchet/version'

module Hatchet

  def logger
    @_hatchet_logger ||= Logger.new self, Hatchet.appenders
  end

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

