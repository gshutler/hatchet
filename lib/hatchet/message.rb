# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Class for wrapping message strings and blocks in a way that means
  # they can be treated identically.
  #
  # If an error is associated with the message this will be available via the
  # #error attribute.
  #
  # Blocks will be lazily evaluated once for all appenders when required.
  #
  class Message

    # Public: Gets the error associated with this message, if given.
    #
    attr_reader :error

    # Public: Gets the nested diagnostic context values.
    #
    attr_reader :ndc

    # Public: Creates a new message.
    #
    # args  - The Hash used to provide context for the message (default: {}):
    #         :ndc     - An Array of nested diagnostic context values
    #                    (default: []).
    #         :message - An already evaluated message, usually a String
    #                    (default: nil).
    #         :error   - An error that is associated with the message
    #                    (default: nil).
    # block - An optional block which will provide a message when invoked.
    #
    # One of message or block must be provided. If both are provided then the
    # block is preferred as it is assumed to provide more detail.
    #
    # Examples
    #
    #   Message.new(ndc: [], message: "Evaluated message", error: e)
    #   Message.new(ndc: %w{Foo Bar}) { "Lazily evaluated message" }
    #
    # The signature of the constructor was originally:
    #
    # message - An already evaluated message, usually a String (default: nil).
    # error   - An error that is associated with the message (default: nil).
    # block   - An optional block which will provide a message when invoked.
    #
    # This format is also supported for compatibility to version 0.1.0 and below
    # and will be deprecated in the future.
    #
    # Examples
    #
    #   Message.new("Evaluated message", e)
    #   Message.new { "Lazily evaluated message" }
    #
    def initialize(args = {}, error = nil, &block)
      if args.kind_of? Hash
        # If args is a Hash then using new constructor format or no parameters
        # specified. Either way, use the new format.
        @ndc     = args[:ndc] || []
        @error   = args[:error]
        @message = args[:message] unless block
      else
        # Otherwise assume the old format and coerce args accordingly.
        @ndc = []
        @error = error
        @message = args unless block
      end

      @block   = block
    end

    # Public: Returns the String representation of the message.
    #
    def to_s
      @message ||= @block.call
    end

  end

end

