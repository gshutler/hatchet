# -*- encoding: utf-8 -*-

require 'json'

module Hatchet

  # Public: Structured formatter class. Outputs messages as JSON strings.
  #
  class StructuredFormatter
    include BacktraceFormatter

    # Public: Creates a new instance.
    #
    def initialize
      @backtrace = true
      @secs = 0
      @millis = -1
      @level_cache = {}
    end

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns messages in the format:
    #
    #   %Y-%m-%d %H:%M:%S.%L [THREAD] LEVEL CONTEXT - MESSAGE
    #       BACKTRACE
    #
    # The backtrace is only present if the message contains an error.
    #
    def format(level, context, message)
      msg = message.evaluated_message

      case msg
      when Hash
        # Assume caller is following conventions
        values = msg.dup
        log_message = values.delete(:message)
        log = {
          :message => log_message.to_s.strip,
          :values => values,
        }
      else
        # Otherwise treat as String
        log = { :message => msg.to_s.strip }
      end

      log[:timestamp] = timestamp
      log[:level] = format_level(level)
      log[:pid] = Process.pid

      unless Thread.current == Thread.main
        log[:thread] = Thread.current.object_id
      end

      log[:context] = context

      if message.ndc.any?
        log[:ndc] = message.ndc.to_a
      end

      if message.error
        log[:error] = structured_error(message.error)
      end

      JSON.generate(log.to_h)
    end

    private

    def structured_error(error)
      details = {
        :class => error.class.to_s,
        :message => error.message,
      }

      if error.respond_to?(:backtrace)
        backtrace = error.backtrace
        backtrace = backtrace.take(backtrace_limit) if backtrace_limit
        details[:backtrace] = backtrace
      end

      details
    end

    # Private: Returns the current time as a String.
    #
    def timestamp
      time = Time.now.getutc

      secs = time.to_i
      millis = time.nsec/1000000

      return @last if @millis == millis && @secs == secs

      unless secs == @secs
        @secs = secs
        @date = time.strftime('%Y-%m-%d %H:%M:%S.')
      end

      @millis = millis
      @last = @date + "00#{millis}"[-3..-1] + "Z"
    end

    # Private: Returns the level formatted for log output as a String.
    #
    def format_level(level)
      @level_cache[level] ||= level.to_s.upcase
    end
  end
end
