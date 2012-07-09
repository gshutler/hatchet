# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Standard formatter class.
  #
  class StandardFormatter

    def initialize
      @secs = 0
    end

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns the context and message separated by a hypen.
    #
    def format(level, context, message)
      "#{timestamp} [#{thread_name}] #{format_level level} #{context} - #{message}"
    end

    private

    # Private: Returns the current time as a String.
    #
    def timestamp
      time = Time.now

      if (secs = time.to_i) > @secs
        @secs = secs
        @date = time.strftime('%Y-%m-%d %H:%M:%S.')
      end

      @date + (time.usec/1000).to_s.rjust(3,'0')
    end

    # Private: Returns the name of the current thread from the processes pid and
    # the threads object_id when it is not the main thread for the process.
    #
    def thread_name
      if Thread.current == Thread.main
        Process.pid
      else
        "#{Process.pid}##{Thread.current.object_id}"
      end
    end

    # Private: Returns the level formatted for log output as a String.
    #
    def format_level(level)
      level.to_s.upcase.ljust(5)
    end

  end

end

