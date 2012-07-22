# -*- encoding: utf-8 -*-

class DisabledAppender

  attr_reader :add_called

  def enabled?(level, context)
    false
  end

  def add(level, context, message)
    @add_called = true
  end

end

