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

  class LoggerAppender

    LEVELS = [:trace, :debug, :info, :warn, :error, :fatal, :off]

    attr_accessor :levels

    attr_accessor :logger

    attr_accessor :formatter

    def initialize(args = {})
      @logger = args[:logger]
      @formatter = args[:formatter]
      yield self
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{timestamp} [#{thread_name}] #{severity.ljust 5} #{msg}\n"
      end
    end

    def add(level, context, msg)
      return unless enabled? context, level
      @logger.send level, @formatter.format(context, msg)
    end

    def enabled?(context, level)
      unless self.levels.key? context
        lvl = self.levels[nil]
        root = []
        context.to_s.split('::').each do |part|
          root << part
          path = root.join '::'
          lvl = self.levels[path] if self.levels.key? path
        end
        self.levels[context] = lvl
      end
      LEVELS.index(level) >= LEVELS.index(self.levels[context])
    end

    private

    def timestamp
      Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
    end

    def thread_name
      if Thread.current == Thread.main
        Process.pid
      else
        "#{Process.pid}##{Thread.current.object_id}"
      end
    end

  end

  class StandardFormatter

    def format(context, msg)
      "#{context} - #{msg.call}"
    end

  end

  class Configuration

    attr_reader :levels

    attr_reader :appenders

    def initialize
      @levels = {}
      @levels[nil] = :info
      @appenders = []
      yield self if block_given?
    end

    def level(level, context = nil)
      context = context.to_s unless context.nil?
      @levels[context] = level
    end

  end

  class Logger

    def initialize(host, appenders)
      @context = context host
      @appenders = appenders
    end

    [:trace, :debug, :info, :warn, :error, :fatal].each do |level|
      define_method level do |*args, &block|
        msg = args[0]
        block = Proc.new { msg } unless msg.nil? or block
        return if block.nil?
        add level, block
      end
    end

    private

    def add(level, msg)
      @appenders.each { |appender| appender.add(level, @context, msg) }
    end

    def context(host)
      if host.inspect == 'main'
        'main'
      elsif host.class == Module
        host
      else
        host.class
      end
    end

  end

end

