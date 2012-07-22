# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Simple formatter class. Outputs messages with just level, context,
  # and message.
  #
  class SimpleFormatter

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns messages in the format:
    #
    #   LEVEL - CONTEXT - MESSAGE
    #
    def format(level, context, message)
      message = message.to_s.strip
      "#{level.to_s.upcase} - #{context} - #{message}"
    end

  end

end

