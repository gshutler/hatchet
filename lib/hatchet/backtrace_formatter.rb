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
        indented_backtrace = error.backtrace.map { |line| "    #{line}" }.to_a
        msg = ([msg] + indented_backtrace).join("\n")
      end

      msg
    end

  end

end

