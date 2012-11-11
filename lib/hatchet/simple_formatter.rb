# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Simple formatter class. Outputs messages with just level, context,
  # and message.
  #
  class SimpleFormatter
    include BacktraceFormatter

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
      msg = "#{level.to_s.upcase} - #{context} - #{msg}"

      with_backtrace(message, msg)
    end

  end

end

