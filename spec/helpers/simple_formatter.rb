# -*- encoding: utf-8 -*-

require 'ostruct'

class SimpleFormatter
  def format(level, context, message)
    OpenStruct.new(level: level, context: context, message: message)
  end
end

