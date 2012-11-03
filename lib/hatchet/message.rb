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

    # Internal: Creates a new message.
    #
    # message - An already evaluated message, usually a String (default: nil).
    # error   - An error that is associated with the message (default: nil).
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
    def initialize(message = nil, error = nil, &block)
      @block = block
      @error = error
      @message = message unless @block
    end

    # Internal: Returns the String representation of the message.
    #
    def to_s
      @message ||= @block.call
    end

  end

end

