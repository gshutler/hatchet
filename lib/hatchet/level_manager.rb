# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Module for managing the configuration of log levels on a class or
  # module level. Useful when you are creating custom appenders.
  #
  module LevelManager

    # Internal: All the possible levels of log filter in order of severity.
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
    #
    def levels=(levels)
      @levels = levels
      clear_levels_cache!
    end

    # Public: Set the lowest level of message to log for the given context.
    #
    # level   - The lowest level of message to log for the given context.
    # context - The context that level applies to (default: nil).
    #
    # Setting a level for nil sets the default level for all contexts that have
    # not been specified.
    #
    # Returns nothing.
    #
    def level(level, context = nil)
      context = context.to_s unless context.nil?
      self.levels[context] = level
      clear_levels_cache!
    end

    # Internal: Returns the default level of the configuration.
    #
    def default_level
      self.levels[nil]
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
      unless self.levels_cache.key? context
        lvl = self.levels_cache[nil]
        root = []
        context.to_s.split('::').each do |part|
          root << part
          path = root.join '::'
          lvl = self.levels_cache[path] if self.levels_cache.key? path
        end
        self.levels_cache[context] = lvl
      end
      LEVELS.index(level) >= LEVELS.index(self.levels_cache[context])
    end

    # Internal: Returns a lazily duplicated Hash from the levels Hash which is
    # used to store the calculated logging level for specific contexts to make
    # subsequent lookups more efficient.
    #
    def levels_cache
      @_levels_cache ||= self.levels.dup
    end

    # Internal: Removes the caching Hash so that it will be re-initialized.
    #
    # Used when a change to logging levels is made so that the cache will not
    # contain stale values.
    #
    def clear_levels_cache!
      @_levels_cache = nil
    end

  end

end

