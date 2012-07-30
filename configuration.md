---
layout: default
title: Hatchet - Configuration
---

# Configuration

Hatchet's configuration revolves around three concepts:

 * [Levels](#levels)
 * [Appenders](#appenders)
 * [Formatters](#formatters)

Hatchet knows about the 5 standard log levels:

 * `:debug`
 * `:info`
 * `:warn`
 * `:error`
 * `:fatal`

The meanings of these levels are identical to
[their meanings in the standard Ruby Logger](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html).

Hatchet comes with one appender out of the box, the `LoggerAppender`. This is an
appender that delegates its log calls to an instance of the standard Ruby
logger.

Hatchet also comes with three formatters, the `PlainFormatter`, the
`StandardFormatter`, and the `SimpleFormatter`.

The `PlainFormatter` is a formatter that outputs messages as they are received
with no additional information or cleansing.

The `StandardFormatter` is a formatter that outputs messages in the TTCC format
of log4j. This is a format that is easy to grep and works well with log
monitoring tools like [Chainsaw](http://logging.apache.org/chainsaw/index.html).

> The [development version of Chainsaw](http://people.apache.org/~sdeboy/) plays
> best with Hatchet's output.

The `SimpleFormatter` is formats messages similarly to the `StandardFormatter`
but only outputs the level, context, and text of the log message.

### Example Configuration

This is an example bringing together all the functionality of [levels](#levels),
[appenders](#appenders), and [formatters](#formatters) into a single example of
logging nirvana:

{% highlight ruby %}
Hatchet.configure do |config|
  config.level :warn
  config.level :debug, 'Application::BankTransfer'

  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.logger = Logger.new('log/application.log')
  end

  config.appenders << CustomEmailAppender.new do |appender|
    appender.level :fatal
    appender.formatter = CustomEmailFormatter.new
    appender.recipient = 'alerts@example.com'
  end
end
{% endhighlight %}

This creates a Hatchet configuration that logs `:warn` and higher messages to
file by default but adds a special case for the `Application::BankTransfer`
class it logs `:debug` and higher messages. If a fatal message is ever logged it
will also send an email about it, in a pretty format, to `alerts@example.com`.

All this functionality is abstracted away from your application code. Your
application calls the logging methods in the same way regardless of the number
of appenders.

## Levels

Hatchet knows about the 5 standard log levels:

 * `:debug`
 * `:info`
 * `:warn`
 * `:error`
 * `:fatal`

The meanings of these levels are identical to
[their meanings in the standard Ruby Logger](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html).

The configuration object has a `level` method that takes the level you want to
log at and an optional scope that level applies to. If no scope is specified
then it sets the default level to be used if no specific level is set for
the scope of a logging call.

Scope is defined hierarchically at the module and/or class level. For example,
if we have the class `Application::Models::Person` we can specify the level for
logging within that class through 4 levels of scope:

{% highlight ruby %}
Hatchet.configure do |config|
  config.level :error
  config.level :warn,  'Application'
  config.level :info,  'Application::Models'
  config.level :debug, 'Application::Models::Person'
end
{% endhighlight %}

The logging level is taken from the most specific scope for the context of the
logging call, not the order in which the levels are specified.

For the above configuration:

 * For the `Application::Models::Person` class `:debug` and higher messages will
   be logged due to the configuration of the `Application::Models::Person` scope
 * For the `Application::Models::Company` class `:info` and higher messages will
   be logged due to the configuration of the `Application::Models` scope
 * For the `Application::Controllers::HomeController` class `:warn` and higher
   messages will be logged due to the configuration of the `Application` scope
 * For the `SomeGem` module (if it were using Hatchet) `:error` and higher
   messages will be logged due to the configuration of the default scope

Individual appenders can have their levels configured separately. However, if
their levels are not touched during configuration then Hatchet will share the
default set of levels with them.

## Appenders

Hatchet has the concept of appenders as unlike the standard `Logger` class a
single message can be logged to many destinations. For example, you might want
to log all `:warn` and higher messages to a regular log file on disk but you
might want to receive an email whenever a `:fatal` message is logged. Hatchet
allows you to do this through a single logging interface.

The configuration object has a `appenders` array that contains all the
appenders that should process each logging message. Adding a new appender is as
simple as appending a new appender instance to this array. Whether the appender
writes the message to its destination or not depends on [how its levels are configured](#levels),
be it through inheriting the default levels or having its own levels explicitly
set.

For our example of a log file recording all `:warn` and higher messages and an
appender emailing all `:fatal` messages the configuration would look like this:

{% highlight ruby %}
Hatchet.configure do |config|
  config.level :warn

  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.logger = Logger.new('log/application.log')
  end

  config.appenders << CustomEmailAppender.new do |appender|
    appender.level :fatal
    appender.recipient 'alerts@example.com'
  end
end
{% endhighlight %}

Related:

 * [Creating an appender](/hatchet/extending/appenders.html)
 * [Known appenders](/hatchet/extensions.html#appenders)

## Formatters

Hatchet has the concept of formatters which are classes that receive the level
and context of a message and produce a formatted message including the text
specified as part of the logging call.

Formatters are specific to each appender. If no formatter is assigned to the
`formatter` property of an appender then Hatchet will give it an instance of the
`StandardFormatter` that comes with Hatchet.

The `StandardFormatter` outputs messages in the TTCC of log4j. This is a format
that is easy to grep and works well with log monitoring tools like [Chainsaw](http://logging.apache.org/chainsaw/index.html).

If you don't like that type of output you can set the formatter of your appender
to a formatter you do like the style of:

{% highlight ruby %}
Hatchet.configure do |config|
  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.formatter = CustomFormatter.new
  end
end
{% endhighlight %}

You can also change the default formatter used by all appenders:

{% highlight ruby %}
Hatchet.configure do |config|
  config.formatter = CustomFormatter.new
end
{% endhighlight %}

Changing the default formatter will change the formatter for all future
appenders and all those already using the default appender.

Related:

 * [Creating a formatter](/hatchet/extending/formatters.html)
 * [Known formatters](/hatchet/extensions.html#formatters)

