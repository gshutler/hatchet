---
layout: default
title: Hatchet - Creating an appender
---

# Creating an appender

## Interface

Appenders are classes with an interface of:

{% highlight ruby %}
class CustomAppender

  def enabled?(level, context)
    # Code determining whether messages will be logged for the
    # level and context.
  end

  def add(level, context, message)
    # Code to conditionally log messages.
  end

end
{% endhighlight %}

## Standard functionality

It is recommended you make your appender's [logging level](/hatchet/configuration.html#levels)
and [message formatting](/hatchet/configuration.html#formatters) configurable in
the same way as standard appenders.

### Level management

The level management functionality has been encapsulated in [LevelManager](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/level_manager.rb)
which you can mix into your own classes:

{% highlight ruby %}
class CustomAppender
  include Hatchet::LevelManager

  def add(level, context, message)
    return unless enabled? level, context
    # Code to conditionally log messages
  end

end
{% endhighlight %}

### Message formatting


