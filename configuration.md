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
[their meanings in the standard Ruby Logger](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html)

Hatchet comes with one appender out of the box, the `LoggerAppender`. This is an
appender that delegates its log calls to an instance of the standard Ruby
logger.

Hatchet also comes with one formatter, the `StandardFormatter`. This is a
formatter that outputs messages in the TTCC of log4j. This is a format that is
easy to grep and works well with log monitoring tools like
[Chainsaw](http://logging.apache.org/chainsaw/index.html).

> The [development version of Chainsaw](http://people.apache.org/~sdeboy/) plays
> best with Hatchet's output.

### Example Configuration

{% highlight ruby %}
Hatchet.configure do |config|
  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.logger = Logger.new('log/test.log')
  end
end
{% endhighlight %}

## Levels

TODO

## Appenders

TODO

## Formatters

TODO

