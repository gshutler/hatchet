# -*- encoding: utf-8 -*-

require 'ostruct'

class LoggerDouble
  attr_accessor :level
  attr_accessor :formatter
  attr_reader :messages

  def initialize
    @messages = []
  end

  [:debug, :info, :warn, :error, :fatal].each do |level|
    define_method level do |message|
      messages << OpenStruct.new(level: level, message: message)
    end
  end
end

