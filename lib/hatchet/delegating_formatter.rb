# -*- encoding: utf-8 -*-

module Hatchet

  # Internal: Formatter class that delegates to another formatter
  # implementation. Used within the configuration to make it possible to switch
  # the default formatter at any time.
  #
  class DelegatingFormatter

    # Internal: Gets or sets the formatter that is delegated to.
    #
    attr_accessor :formatter

    # Internal: Creates a new instance.
    #
    # formatter - The formatter to delegate to initially.
    #
    def initialize(formatter)
      @formatter = formatter
    end

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns messages as formatted by the formatter being delegated to.
    #
    def format(level, context, message)
      @formatter.format(level, context, message)
    end

  end

end

