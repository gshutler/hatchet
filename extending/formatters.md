---
layout: default
title: Hatchet - Creating a formatter
---

# Creating a formatter

Throughout this page we will build up a custom formatter. Going from a stub of
the required method through to a complete, configurable formatter reader for use
with Hatchet.

## Interface

Formatters are classes with an interface of:

{% highlight ruby %}
class CustomFormatter

  def format(level, context, message)
    # Code to format a message.
  end

end
{% endhighlight %}

### format

Returns a formatted message ready for logging.

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

The `Hatchet::Message` to log.

### Remarks

When generating `Strings` it should not have any leading or trailing whitespace
as this should be left up to the calling appender to add as it requires. This
will make your formatter more reusable across appenders.

## Summary

There's not much more to creating a custom formatter. It simply takes the
parameters of the logging message and transforms them into something ready to be
logged.

You can of course provide additional information about the environment. For
example, the [`StandardFormatter`](https://github.com/gshutler/hatchet/blob/master/lib/hatchet/standard_formatter.rb)
adds details such as the current time and details of the thread the logging call
was made from. Formatters are expected to be called within the same execution
context as the initial logging call.

Something to note is that formatters don't necessarily have to return `Strings`.
If the appender supports it the formatter could create objects suitable for
transforming to JSON or bytes ready to be sent somewhere over a port.

Remember not to reinvent the wheel and first check the [list of known formatters](/hatchet/extensions.html#formatters)
for an existing formatter that does what you want and contribute to that if it
isn't quite right for your needs.

