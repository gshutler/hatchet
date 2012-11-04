# -*- encoding: utf-8 -*-

module Hatchet

  # Public: Class that handles logging calls and distributes them to all its
  # appenders.
  #
  # Each logger has 5 logging methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal
  #  * error
  #  * warn
  #  * info
  #  * debug
  #
  # All these methods have the same signature. You can either provide a message
  # as a direct string, or as a block to the method is lazily evaluated (this is
  # the recommended option).
  #
  # Examples
  #
  #   logger.info "Informational message"
  #   logger.info { "Informational message #{potentially_expensive}" }
  #
  # Log messages are sent to each appender where they will be filtered and
  # invoked as configured.
  #
  # Each logger also has 5 inspection methods. Those are, in decreasing order of
  # severity:
  #
  #  * fatal?
  #  * error?
  #  * warn?
  #  * info?
  #  * debug?
  #
  # All these methods take no arguments and return true if any of the loggers'
  # appenders will log a message at that level for the current context,
  # otherwise they will return false.
  #
  class HatchetLogger

    # Internal: Map from standard library levels to Symbols.
    #
    STANDARD_TO_SYMBOL = {
      Logger::DEBUG => :debug,
      Logger::INFO  => :info,
      Logger::WARN  => :warn,
      Logger::ERROR => :error,
      Logger::FATAL => :fatal
    }

    # Internal: Creates a new logger.
    #
    # host          - The object the logger gains its context from.
    # configuration - The configuration of Hatchet.
    #
    def initialize(host, configuration)
      @context = context host
      @configuration = configuration
      @appenders = configuration.appenders
    end

    [:debug, :info, :warn, :error, :fatal].each do |level|

      # Public: Logs a message at the given level.
      #
      # message - An already evaluated message, usually a String (default: nil).
      # error   - An error which is associated with the message (default: nil).
      # block   - An optional block which will provide a message when invoked.
      #
      # One of message or block must be provided. If both are provided then the
      # block is preferred as it is assumed to provide more detail.
      #
      # In general, you should use the block style for any message not related
      # to an error. This is because any unneccessary String interpolation is
      # avoided making unwritten debug calls, for example, less expensive.
      #
      # When logging errors it is advised that you include some details of the
      # error within the regular message, perhaps the error's message, but leave
      # the inclusion of the stack trace up to your appenders and their
      # formatters.
      #
      # Examples
      #
      #   debug { "A fine grained message" }
      #   info  { "An interesting message" }
      #   warn  { "A message worth highlighting" }
      #   error "A message relating to an exception", e
      #   fatal "A message causing application failure", e
      #
      # Returns nothing.
      #
      define_method level do |message = nil, error = nil, &block|
        return unless message or block
        add level, Message.new(message, error, &block)
      end

      # Public: Returns true if any of the appenders will log messages for the
      # current context, otherwise returns false.
      #
      # Writes messages to STDOUT if any appender fails to complete the check.
      #
      define_method "#{level}?" do
        @appenders.any? do |appender|
          begin
            appender.enabled? level, @context
          rescue => e
            puts "Failed to check if level #{level} enabled for #{context} with appender #{appender}\n"
            false
          end
        end
      end

    end

    # Public: Returns the default level of the logger's configuration.
    #
    def level
      @configuration.default_level
    end

    # Public: Set the lowest level of message to log by default.
    #
    # level - The lowest level of message to log by default.
    #
    # The use of this method is not recommended as it affects the performance of
    # the logging. It is only provided for compatibility.
    #
    # Returns nothing.
    #
    def level=(level)
      level = case level
              when Symbol
                level
              else
                STANDARD_TO_SYMBOL[level] || :info
              end

      @configuration.level level
    end

    private

    # Private: Adds a message to each appender at the specified level.
    #
    # level   - The level of the message. One of, in decreasing order of
    #           severity:
    #
    #             * fatal
    #             * error
    #             * warn
    #             * info
    #             * debug
    #
    # message - The message that will be logged by an appender when it is
    #           configured to log at the given level or lower.
    #
    # Writes messages to STDOUT if any appender fails to complete the enabled
    # check or log the message.
    #
    # Returns nothing.
    #
    def add(level, message)
      @appenders.each do |appender|
        if appender.enabled?(level, @context)
          begin
            appender.add(level, @context, message)
          rescue => e
            puts "Failed to log message for #{@context} with appender #{appender} - #{level} - #{message}\n"
            puts "#{e}\n"
          end
        end
      end
      nil
    end

    # Private: Determines the contextual name of the host object.
    #
    # host - The object hosting this logger.
    #
    # Returns the String 'main' if this is the initial execution context of
    # Ruby, the host itself when the host is a module, otherwise the object's
    # class.
    #
    def context(host)
      if host.inspect == 'main'
        'main'
      elsif [Module, Class].include? host.class
        host
      else
        host.class
      end
    end

  end

end

