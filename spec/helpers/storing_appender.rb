# -*- encoding: utf-8 -*-

class StoringAppender
  include LevelManager

  attr_accessor :formatter

  attr_reader :messages

  def initialize(default_level = nil)
    @messages = []
    @levels = {}
    @levels[nil] = default_level unless default_level.nil?
    yield self if block_given?
  end

  def add(level, context, message)
    @messages << OpenStruct.new(level: level, context: context, message: message)
  end
end

