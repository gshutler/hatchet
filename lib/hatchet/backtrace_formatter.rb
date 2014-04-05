# -*- encoding: utf-8 -*-

module Hatchet

  # Internal: Module for handling the common code for conditionally including
  # the backtrace within a formatted message.
  #
  module BacktraceFormatter

    # Public: Gets whether backtraces are enabled.
    #
    # Defaults to true if it has not been set.
    #
    def backtrace
      @backtrace.nil? ? true : @backtrace
    end

    # Public: Sets whether backtraces should be enabled.
    #
    # value - True if backtraces should be enabled, otherwise false.
    #
    def backtrace=(value)
      @backtrace = value
    end

    # Public: Gets and sets the number of lines to limit backtraces to.
    #
    # If set to nil, the entire backtrace will be used.
    #
    attr_accessor :backtrace_limit

    private

    # Private: Method that takes an already formatted message and appends the
    # backtrace to it if there is one and backtraces are enabled.
    #
    # message                   - The Message that is being formatted.
    # message_without_backtrace - The formatted message before a backtrace may
    #                             be added.
    #
    # Returns a message with a backtrace optionally appended to it.
    #
    def with_backtrace(message, message_without_backtrace)
      msg = message_without_backtrace
      error = message.error

      if self.backtrace && error && error.respond_to?(:backtrace)
        backtrace = if backtrace_limit
                      error.backtrace.take(backtrace_limit)
                    else
                      error.backtrace
                    end

        indented_backtrace = backtrace.map { |line| "    #{line}" }.to_a
        msg = indented_backtrace.insert(0, msg).join("\n")
      end

      msg
    end

  end

end

