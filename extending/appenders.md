---
layout: default
title: Hatchet - Creating an appender
---

# Creating an appender

Throughout this page we will build up a custom appender. Going from a stub of
the required methods through to a complete, configurable appender ready for use
with Hatchet.

## Interface

Appenders are classes with an interface of:

{% highlight ruby %}
class CustomAppender

  def enabled?(level, context)
    # Code determining whether messages will be logged for the
    # level and context.
    #
    # For the majority of cases you do not need to implement this yourself.
    # Instead you can include the Hatchet::LevelManager module into your class
    # this will do the work required for you.
  end

  def add(level, context, message)
    # Code to log a message.
  end

end
{% endhighlight %}

### enabled?

Returns `true` if the appender should log messages for the given level and
context, otherwise returns `false`.

#### level

A Symbol representing the level of the log call. One of, in decreasing level of
severity:

 * `:fatal`
 * `:error`
 * `:warn`
 * `:info`
 * `:debug`

#### context

An object representing the context of the log call. When transformed to a
`String` by calling `to_s` it will represent a hierarchy with each level
separated by `::`.

### add

Adds a message to the logging destination.

#### level

A Symbol representing the level of the log call. One of, in descreasing level of
severity:

 * `:fatal`
 * `:error`
 * `:warn`
 * `:info`
 * `:debug`

#### context

An object representing the context of the log call. When transformed to a
`String` by calling `to_s` it will represent a hierarchy with each level
separated by `::`.

#### message

The [`Hatchet::Message`](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/message.rb)
to log.

### Remarks

The `add` method will only be called by Hatchet if the `enabled?` method returns
`true` for a given logging call.

## Standard functionality

It is recommended you make your appender's [logging level](/hatchet/configuration.html#levels)
and [message formatting](/hatchet/configuration.html#formatters) configurable in
the same way as standard appenders.

### Level management

The level management functionality has been encapsulated in [`LevelManager`](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/level_manager.rb)
which you can mix into your own classes:

{% highlight ruby %}
class CustomAppender
  include Hatchet::LevelManager

  def intialize
    yield self if block_given?
  end

  def add(level, context, message)
    # Code to log a message.
  end

end
{% endhighlight %}

The [`LevelManager`](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/level_manager.rb)
adds the standard `level` configuration method to your appender and implements
the `enabled?` method too.

### Configuration

Appenders are expected to yield themselves to a block, when given, upon
creation:

{% highlight ruby %}
class CustomAppender
  include Hatchet::LevelManager

  def intialize
    yield self if block_given?
  end

  def add(level, context, message)
    # Code to log a message.
  end

end
{% endhighlight %}

### Message formatting

It is recommended that you format messages via a formatter object. This will
enable users of your appender to easily change the format of messages it
produces without you having to modify your appender.

Of course, you can specify a preferred formattr by setting that as the default.
You may even chose to ship a [custom formatter](/hatchet/extending/formatters.html)
alongside your appender.

{% highlight ruby %}
class CustomAppender
  include Hatchet::LevelManager

  attr_accessor :formatter

  def intialize
    # If you want to set a default formatter do that before
    # yielding for client configuration.
    @formatter = CustomFormatter.new
    yield self if block_given?
  end

  def add(level, context, message)
    message = @formatter.format(level, context, message)
    # Code to log a message.
  end

end
{% endhighlight %}

## Implementation

All that is left is for our logger to implement the logging of messages. We will
keep this simple and just make it log to `STDOUT`:

{% highlight ruby %}
class CustomAppender
  include Hatchet::LevelManager

  attr_accessor :formatter

  def intialize
    yield self if block_given?
  end

  def add(level, context, message)
    puts @formatter.format(level, context, message)
  end

end
{% endhighlight %}

That's all there is to creating a custom appender. You should be able to see the
same structure in the [`LoggerAppender`](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/logger_appender.rb)
that comes with Hatchet and the [`HipChatAppender`](https://github.com/gshutler/hatchet-hipchat/blob/master/lib/hatchet-hipchat.rb)
from [hatchet-hipchat](https://github.com/gshutler/hatchet-hipchat).

Remember not to reinvent the wheel and first check the [list of known appenders](/hatchet/extensions.html#appenders)
for an existing appender that does what you want and contribute to that if it
isn't quite right for your needs.

