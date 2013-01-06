module Hatchet

  # Public: Class that manages the nested diagnostic context for a thread.
  #
  # All access to this class is performed through internal classes.
  #
  class NestedDiagnosticContext

    # Internal: Gets the NestedDiagnosticContext for the current thread, lazily
    # initializing it as necessary.
    #
    def self.current
      Thread.current[:hatchet_ndc] ||= NestedDiagnosticContext.new
    end

    # Internal: Creates a new instance of the class.
    #
    def initialize
      clear!
    end

    # Public: Adds one or more messages onto the context stack.
    #
    # values - One or more messages to add to the context stack.
    #
    # Returns nothing.
    #
    def push(*values)
      @context.push(*values)
      nil
    end

    # Public: Removes one or more message from the context stack.
    #
    # n - The number of messages to remove from the context stack (default:
    #     nil). If no number is provided then one message will be removed.
    #
    # Returns the message or messages removed from the context stack. If n was
    # not specified it will return a single message, otherwise it will return an
    # Array of up to n messages.
    #
    def pop(n = nil)
      if n
        @context.pop(n)
      else
        @context.pop
      end
    end

    # Public: Adds one more or message onto the context stack for the scope of
    # the given block.
    #
    # values - One or more messages to add to the context stack for the scope of
    #          the given block.
    # block  - The block to execute with the additional messages.
    #
    # Returns the result of calling the block.
    #
    def scope(*values, &block)
      before = @context.clone
      push(*values)
      block.call
    ensure
      @context = before
    end

    # Public: Clears all messages from the context stack.
    #
    # Intend for use when the current thread is, or may, be reused in the future
    # and the accumlated context is no longer wanted.
    #
    # Returns nothing.
    #
    def clear!
      @context = []
      nil
    end

    # Internal: Returns the Array of messages of the current context stack.
    #
    def to_a
      @context.clone
    end

  end

end

