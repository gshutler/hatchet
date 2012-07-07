require_relative 'lumberjack/version'
require 'logger'

module Lumberjack

  def log
    @log ||= Logger.new self, Lumberjack.appenders
  end

  alias_method :logger, :log

  def self.appenders
    @@appender ||= begin
      levels = {}
      levels[nil] = :warn
      levels['Namespace::Something'] = :debug
      [LoggerAppender.new(StandardFormatter.new, levels, 'log/test.log')]
    end
  end

  class LoggerAppender

    LEVELS = [:trace, :debug, :info, :warn, :error, :fatal, :off]

    def initialize(formatter, levels, *args)
      @logger = ::Logger.new(*args)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{timestamp} [#{thread_name}] #{severity.ljust 5} #{msg}\n"
      end
      @formatter = formatter
      @levels = levels
    end

    def add(level, context, msg)
      return unless enabled? context, level
      @logger.send level, "#{@formatter.format(context, msg)}"
    end

    def enabled?(context, level)
      unless @levels.key? context
        lvl = @levels[nil]
        root = []
        context.to_s.split('::').each do |part|
          root << part
          path = root.join '::'
          lvl = @levels[path] if @levels.key? path
        end
        @levels[context] = lvl
      end
      LEVELS.index(level) >= LEVELS.index(@levels[context])
    end

    private

    def timestamp
      Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
    end

    def thread_name
      if Thread.current == Thread.main
        "#{Process.pid}#main"
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

  class Logger

    def initialize(host, appenders)
      @context = context host
      @appenders = appenders
    end

    levels = [:trace, :debug, :info, :warn, :error, :fatal]
    levels.reverse.each do |level|
      lvls = levels.dup
      levels.pop
      define_method level do |*args, &block|
        msg = args[0]
        block = Proc.new { msg } unless msg.nil?
        return if block.nil?
        append level, block
      end
    end

    private

    def append(level, msg)
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

