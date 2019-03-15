module Hatchet

  # Public: Class that manages the nested diagnostic context for a thread.
  #
  # All access to this class is performed through internal classes.
  #
  class NestedDiagnosticContext

    # Internal: Gets the current context stack.
    #
    attr_reader :context

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
      @context = ContextStack.new
      nil
    end

    # Public: Class for holding the context stack of a NestedDiagnosticContext.
    #
    # Deliberately intended to have a similar API to Array to make testing
    # easier.
    #
    class ContextStack

      # Internal: Gets the internal stack.
      #
      attr_reader :stack

      # Internal: Creates a new instance.
      #
      # stack - An Array of values to initialize the stack with (default: []).
      #
      def initialize(stack = [])
        @stack = stack
      end

      # Public: Returns true if the stack contains any messages, otherwise
      # returns false.
      #
      def any?
        @stack.size != 0
      end

      # Internal: Returns a clone of the stack.
      #
      def clone
        ContextStack.new(@stack.clone)
      end

      # Public: Returns a String created by converting each message of the stack
      # to a String, separated by separator.
      #
      # separator - The String to separate the messages of the stack with
      #             (default: $,).
      #
      # Returns a String created by converting each message of the stack to a
      # String, separated by separator.
      #
      def join(separator = $,)
        @stack.join(separator)
      end

      # Internal: Pushes the given messages onto the stack.
      #
      # values - One or more messages to add to the context stack.
      #
      # Returns nothing.
      #
      def push(*values)
        @stack.push(*values)
        nil
      end

      # Internal: Removes one or more message from the stack.
      #
      # n - The number of messages to remove from the cstack (default: nil). If
      #     no number is provided then one message will be removed.
      #
      # Returns the message or messages removed from the context stack. If n was
      # not specified it will return a single message, otherwise it will return
      # an Array of up to n messages.
      #
      def pop(n = nil)
        if n
          @stack.pop(n)
        else
          @stack.pop
        end
      end

      # Internal: Returns a copy of the stack as an array.
      #
      def to_a
        @stack.clone.to_a
      end
    end

  end

end

