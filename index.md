---
layout: default
title: Hatchet
---

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

{% highlight ruby %}
class Foo
  include Hatchet

  def work
    log.info { 'Doing some work' }
  end
end

module Bar
  extend Hatchet

  def self.work
    log.info { 'Doing some work' }
  end
end
{% endhighlight %}

# Contributing

1. [Fork it on GitHub](https://github.com/gshutler/hatchet)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new [Pull Request](https://github.com/gshutler/hatchet/pulls)

All pull requests should come complete with tests when appropriate and should
follow the existing style which is best described in
[Github's Ruby style guide](https://github.com/styleguide/ruby/).
