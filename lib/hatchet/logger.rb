# -*- encoding: utf-8 -*-

module Hatchet

  class Logger

    def initialize(host, appenders)
      @context = context host
      @appenders = appenders
    end

    [:trace, :debug, :info, :warn, :error, :fatal].each do |level|
      define_method level do |msg = nil, &block|
        return unless msg or block
        add level, Message.new(msg, &block)
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

