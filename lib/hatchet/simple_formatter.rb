# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Simple formatter class. Outputs messages with just level, context,
  # and message.
  #
  class SimpleFormatter

    # Public: Gets or sets whether backtraces should be output when messages
    # contain an error with one.
    #
    attr_accessor :backtrace

    # Public: Creates a new instance.
    #
    def initialize
      self.backtrace = true
    end

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns messages in the format:
    #
    #   LEVEL - CONTEXT - MESSAGE
    #       BACKTRACE
    #
    # The backtrace is only present if the message contains an error.
    #
    def format(level, context, message)
      msg = message.to_s.strip
      if self.backtrace && message.error && message.error.respond_to?(:backtrace)
        indented_backtrace = message.error.backtrace.map { |line| "    #{line}" }.to_a
        msg = ([msg] + indented_backtrace).join("\n")
      end
      "#{level.to_s.upcase} - #{context} - #{msg}"
    end

  end

end

