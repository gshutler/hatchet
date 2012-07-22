---
layout: default
title: Hatchet
---

# What is Hatchet?

Hatchet is a logging framework written from the ground up in Ruby. It has been
inspired by the likes of [log4j](http://logging.apache.org/log4j/) and [slf4j](http://www.slf4j.org/)
but is not a port of either of them.

Hatchet aims to integrate seamlessly with your Ruby projects and provide a
single logging interface that can pass on messages to any backend you want to
use.

[Read more about Hatchet](/hatchet/about.html)

# Installation

Hatchet has specific hooks for [Rails](/hatchet/install/rails.html) and
[Sinatra](/hatchet/install/sinatra.html) though it is suitable for use in
[any Ruby project](/hatchet/install/ruby.html). Please select the installation
guide that most suits your scenario below:

 * [Install for Rails](/hatchet/install/rails.html)
 * [Install for Sinatra](/hatchet/install/sinatra.html)
 * [Standard Ruby install](/hatchet/install/ruby.html)

# Usage

To use the logger you must add it to your classes as a mixin or use it to extend
your modules. Then you can call the logger through the methods `log` and
`logger`. They are aliases for the same method to ease migration.

### Classes

{% highlight ruby %}
class Foo
  include Hatchet

  def work
    log.info { 'Doing some work' }
  end
end
{% endhighlight %}

### Modules

{% highlight ruby %}
module Bar
  extend Hatchet

  def self.work
    log.info { 'Doing some work' }
  end
end
{% endhighlight %}

## Logging API

The logger has all the core methods you are used to from the standard logger for
logging messages taking either a `String` or a lazily-evaluated block:

 * `debug`
 * `info`
 * `warn`
 * `error`
 * `fatal`

It also has all the methods for checking whether logging is active at a given
level:

 * `debug?`
 * `info?`
 * `warn?`
 * `error?`
 * `fatal?`

The level of logging can be controlled down to the class level and each message
can be logged to several locations. See the
[configuration guide for more details](http://gshutler.github.com/hatchet/configuration.html).

# Contributing

1. [Fork it on GitHub](https://github.com/gshutler/hatchet)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new [Pull Request](https://github.com/gshutler/hatchet/pulls)

All pull requests should come complete with tests when appropriate and should
follow the existing style which is best described in
[Github's Ruby style guide](https://github.com/styleguide/ruby/). Bonus internet
points are provided if you submit a pull request for the `gh-pages` branch too.
