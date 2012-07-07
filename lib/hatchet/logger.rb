module Hatchet

  class Logger

    def initialize(host, appenders)
      @context = context host
      @appenders = appenders
    end

    [:trace, :debug, :info, :warn, :error, :fatal].each do |level|
      define_method level do |*args, &block|
        msg = args[0]
        block = Proc.new { msg } unless msg.nil? or block
        return if block.nil?
        add level, block
      end
    end

    private

    def add(level, msg)
      @appenders.each { |appender| appender.add(level, @context, msg) }
    end

    def context(host)
      if host.inspect == 'main'
        'main'
      elsif host.class == Module
        host
      else
        host.class
      end
    end

  end

end

