# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Plain formatter class. Outputs messages with just the given message.
  #
  # Useful for Rails in development mode where the log messages are intended to
  # be human readable rather than useful for grepping, etc.
  #
  class PlainFormatter

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
    #   MESSAGE
    #       BACKTRACE
    #
    # The backtrace is only present if the message contains an error.
    #
    def format(level, context, message)
      unless self.backtrace && message.error && message.error.respond_to?(:backtrace)
        message.to_s
      else
        indented_backtrace = message.error.backtrace.map { |line| "    #{line}" }.to_a
        ([message.to_s] + indented_backtrace).join "\n"
      end
    end

  end

end

