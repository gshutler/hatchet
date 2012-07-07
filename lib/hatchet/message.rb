# -*- encoding: utf-8 -*-

module Hatchet

  # Internal: Class for wrapping message strings and blocks in a way that means
  # they can be treated identically.
  #
  # Blocks will be lazily evaluated once for all appenders when required.
  class Message

    # Internal: Creates a new message.
    #
    # message - An already evaluated message, usually a String (default: nil).
    # block   - An optional block which will provide a message when invoked.
    #
    # One of message or block must be provided. If both are provided then the
    # block is preferred as it is assumed to provide more detail.
    #
    # Examples
    #
    #   Message.new "Evaluated message"
    #   Message.new { "Lazily evaluated message" }
    #
    def initialize(message = nil, &block)
      @block = block
      @message = message unless @block
    end

    # Internal: Returns the String representation of the message.
    def to_s
      @message ||= @block.call
    end

  end

end

