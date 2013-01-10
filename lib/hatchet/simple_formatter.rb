# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Simple formatter class. Outputs messages with just level, context,
  # and message.
  #
  class SimpleFormatter
    include BacktraceFormatter
    include ThreadNameFormatter

    # Public: Gets or sets whether the context of the thread (pid and thread ID)
    # should be included into the output messages.
    #
    attr_accessor :thread_context

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns messages in the format:
    #
    #   [THREAD] - LEVEL - CONTEXT - MESSAGE
    #       BACKTRACE
    #
    # The backtrace is only present if the message contains an error and the
    # presence of the context of the thread context is managed via the
    # #thread_context attribute.
    #
    def format(level, context, message)
      msg = message.to_s.strip
      thread = thread_context ? "[#{thread_name}] - " : nil

      if message.ndc.any?
        msg = "#{thread}#{level.to_s.upcase} - #{context} #{message.ndc.join(' ')} - #{msg}"
      else
        msg = "#{thread}#{level.to_s.upcase} - #{context} - #{msg}"
      end

      with_backtrace(message, msg)
    end

  end

end

