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
      values = []
      values << [:timestamp, timestamp]
      values << [:level, format_level(level)]
      values << [:pid, Process.pid.to_s]

      unless Thread.current == Thread.main
        values << [:thread, Thread.current.object_id.to_s]
      end

      values << [:context, context]

      if message.ndc.any?
        values << [:ndc, message.ndc.to_a.map { |s| s.to_s }]
      end

      values << [:message, message.to_s.strip]

      if message.error
        values << [:error, structured_error(message.error)]
      end

      JSON.generate(values.to_h)
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
