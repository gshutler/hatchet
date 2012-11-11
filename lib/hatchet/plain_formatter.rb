# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Plain formatter class. Outputs messages with just the given message.
  #
  # Useful for Rails in development mode where the log messages are intended to
  # be human readable rather than useful for grepping, etc.
  #
  class PlainFormatter
    include BacktraceFormatter

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
      with_backtrace(message, message.to_s)
    end

  end

end

