# -*- encoding: utf-8 -*-

module Hatchet

  class Configuration

    attr_reader :levels

    attr_reader :appenders

    def initialize
      @levels = {}
      @levels[nil] = :info
      @appenders = []
      yield self if block_given?
    end

    def level(level, context = nil)
      context = context.to_s unless context.nil?
      @levels[context] = level
    end

  end

end

