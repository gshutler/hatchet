# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Module for managing the configuration of log levels on a class or
  # module level. Useful when you are creating custom appenders.
  #
  module LevelManager

    # Private: All the possible levels of log filter in order of severity.
    #
    LEVELS = [:debug, :info, :warn, :error, :fatal, :off]

    # Public: Returns the Hash containing the log level configuration.
    #
    def levels
      @levels ||= {}
    end

    # Public: Sets the Hash containing the log level configuration.
    #
    # levels - The Hash to use as the log level configuration.
    #
    # Returns nothing.
    def levels=(levels)
      @levels = levels
    end

    # Public: Set the lowest level of message to log for the given context.
    #
    # level   - The lowest level of message to log for the given context.
    # context - The context that level applies to (default: nil).
    #
    # Setting a level for nil set the default level for all contexts that have
    # not been specified.
    #
    # Returns nothing.
    def level(level, context = nil)
      context = context.to_s unless context.nil?
      self.levels[context] = level
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

