# -*- encoding: utf-8 -*-

class FailingAppender
  include LevelManager

  def initialize
    @levels = { nil => :info }
  end

  def add(level, context, message)
    raise StandardError, 'Failing appender'
  end
end

