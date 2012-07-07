# -*- encoding: utf-8 -*-

require 'logger'

module Hatchet

  # Public: Class for wrapping a standard Logger with Hatchet's class/module
  # level log filtering.
  #
  class LoggerAppender

    # Private: All the possible levels of log filter in order of severity.
    #
    LEVELS = [:debug, :info, :warn, :error, :fatal, :off]

    # Public: The Hash containing the log level configuration.
    #
    attr_accessor :levels

    # Public: The Logger the appender encapsulates.
    #
    attr_accessor :logger

    # Public: The formatter used to format the message before they are sent to
    # the logger.
    #
    attr_accessor :formatter

    # Public: Creates a new Logger appender.
    #
    # options - The Hash options used to setup the appender (default: {}).
    #           :formatter - The formatter used to format log messages.
    #           :levels    - The configuration of logging levels to the
    #                        class/module level.
    #           :logger    - The Logger messages are sent to. It will have its
    #                        formatter changed to delegate entirely to the
    #                        appender's formatter and its level set to debug so
    #                        that it does not filter out any messages it is
    #                        sent.
    # block  - Optional block that can be used to customize the appender. The
    #          appender itself is passed to the block.
    #
    # Once the values from the options Hash have been applied and any
    # modifications are made within the block the appender should have its
    # levels, logger, and formatter set.
    #
    def initialize(options = {})
      @formatter = options[:formatter]
      @logger = options[:logger]
      @levels = options[:levels]

      yield self if block_given?

      @logger.level = ::Logger::DEBUG
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
    end

    # Internal: Adds a message to the appender if the appender is configured to
    # log messages at the given level for the given context.
    #
    # level   - The level of the message.
    # context - The context of the message.
    # message - The message to add to the appender if it is configured to log
    #           messages at the given level for the given context.
    #
    # Returns nothing.
    #
    def add(level, context, message)
      return unless enabled? level, context
      @logger.send level, @formatter.format(level, context, message)
    end

    # Internal: Returns true if the appender is configured to log messages of
    # the given level within the given context, otherwise returns false.
    #
    # level   - The level of the message.
    # context - The context of the message.
    #
    # Returns true if the appender is configured to log messages of the given
    # level within the given context, otherwise returns false.
    #
    def enabled?(level, context)
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

  end

end

