# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Standard formatter class.
  #
  class StandardFormatter

    # Public: Returns the formatted message.
    #
    # level   - The severity of the log message.
    # context - The context of the log message.
    # message - The message provided by the log caller.
    #
    # Returns the context and message separated by a hypen.
    #
    def format(level, context, message)
      "#{timestamp} [#{thread_name}] #{level.to_s.upcase.ljust 5} #{message}"
    end

    private

    # Private: Returns the current time as a String.
    #
    def timestamp
      Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
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

  end

end

