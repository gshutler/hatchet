# -*- encoding: utf-8 -*-

require 'ostruct'

class TestFormatter
  def format(level, context, message)
    OpenStruct.new(level: level, context: context, message: message)
  end
end

