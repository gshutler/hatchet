# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Standard formatter class. Outputs messages in the TTCC of log4j.
  #
  class StandardFormatter
    include BacktraceFormatter
    include ThreadNameFormatter

    # Public: Creates a new instance.
    #
    def initialize
      @secs = 0
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
      msg = message.to_s.strip
      msg = "#{timestamp} [#{thread_name}] #{format_level level} #{context} - #{msg}"

      with_backtrace(message, msg)
    end

    private

    # Private: Returns the current time as a String.
    #
    def timestamp
      time = Time.now

      secs = time.to_i
      millis = time.nsec/1000000

      return @last if @millis == millis && @secs == secs

      unless secs == @secs
        @secs = secs
        @date = time.strftime('%Y-%m-%d %H:%M:%S.')
      end

      @millis = millis
      @last = @date + "00#{millis}"[-3..-1]
    end

    # Private: Returns the level formatted for log output as a String.
    #
    def format_level(level)
      level.to_s.upcase.ljust(5)
    end

  end

end

