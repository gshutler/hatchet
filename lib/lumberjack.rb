require_relative 'lumberjack/version'

module Lumberjack

  def info
    log.info self, &block
  end

  def log
    @log ||= Logger.new self, Lumberjack.appenders
  end

  def self.appenders
    @@appender ||= begin
      levels = {}
      levels[nil] = :warn
      levels['Namespace::Something::Nested'] = :debug
      [IOAppender.new(STDOUT, StandardFormatter.new, levels)]
    end
  end

  class IOAppender

    LEVELS = [:trace, :debug, :info, :warn, :error, :fatal, :off]

    def initialize(io, formatter, levels)
      @io = io
      @formatter = formatter
      @levels = levels
    end

    def push(level, klass, msg)
      return unless enabled? klass, level
      @io.puts "#{@formatter.format(level, klass, msg)}\n"
    end

    def enabled?(klass, level)
      unless @levels.key? klass
        lvl = @levels[nil]
        root = []
        klass.to_s.split('::').each do |part|
          root << part
          path = root.join '::'
          lvl = @levels[path] if @levels.key? path
        end
        @levels[klass] = lvl
      end
      LEVELS.index(level) >= LEVELS.index(@levels[klass])
    end

  end

  class StandardFormatter

    def format(level, klass, msg)
      thread = if Thread.current == Thread.main
        "pid:#{Process.pid}"
      else
        "pid:#{Process.pid},thread:#{Thread.current.object_id}"
      end
      "#{level.to_s.upcase.ljust 5} #{Time.now} [#{thread}] #{klass.to_s.ljust 28} - #{msg.call}"
    end

  end

  class Logger

    def initialize(host, appenders)
      @class = host.class == Module ? host : host.class
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
      @appenders.each { |appender| appender.push(level, @class, msg) }
    end

  end

end

