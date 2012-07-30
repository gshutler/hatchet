---
layout: default
title: Hatchet - Extensions
---

# Extensions

 * [Appenders](#appenders)
 * [Formatters](#formatters)

These are lists of known appenders and formatters for Hatchet. If you have
created an appender or formatter then [create an issue on GitHub](https://github.com/gshutler/hatchet/issues)
including the name of your extension, the line required for someone's Gemfile,
and a brief description of what it does. It will then be added to the list.

## Appenders

### Core

Hatchet comes with the [`LoggerAppender`](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/logger_appender.rb)
appender that delegates to a [standard `Logger`](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html).

### hatchet-hipchat

[https://github.com/gshutler/hatchet-hipchat](https://github.com/gshutler/hatchet-hipchat)

{% highlight ruby %}
gem 'hatchet-hipchat'
{% endhighlight %}

An appender that posts messages to HipChat rooms.

## Formatters

### Core

Hatchet comes three formatters, `PlainFormatter`, `StandardFormatter` and
`SimpleFormatter`.

#### PlainFormatter

```
MESSAGE
```

The `PlainFormatter` outputs messages as they are provided without any
additional context or sanitization. This is most useful with Rails' logs as they
are intended to be human readable, particularly when in development.

#### StandardFormatter (default)

```
%Y-%m-%d %H:%M:%S.%L [THREAD] LEVEL CONTEXT - MESSAGE
```

The `StandardFormatter` outputs messages in the TTCC of log4j. This is a format
that is easy to grep and works well with log monitoring tools like [Chainsaw](http://logging.apache.org/chainsaw/index.html).

#### SimpleFormatter

```
LEVEL - CONTEXT - MESSAGE
```

The `SimpleFormatter` outputs messages in a simpler format for when the time an
thread of the message is provided by some other means. For example, Heroku adds
the timestamp and thread to log messages of its own accord so it does not need
to be duplicated.

