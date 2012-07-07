# -*- encoding: utf-8 -*-

module Hatchet

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

end

