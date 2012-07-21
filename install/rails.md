---
layout: default
title: Hatchet - Rails Installation
---

# Rails Installation

Hatchet includes a Railtie that is loaded automatically and wraps the
`Rails.logger`.

Add this line to your application's Gemfile to get Hatchet from
[RubyGems.org](https://rubygems.org/gems/hatchet):

{% highlight ruby %}
gem 'hatchet'
{% endhighlight %}

And then execute:

    $ bundle

To make it so your log calls are scoped to your controllers you also need to add
Hatchet to your `ApplicationController`:

{% highlight ruby %}
class ApplicationController < ActionController::Base
  include Hatchet
end
{% endhighlight %}

You could include it in your models so that each of those has its own logging
context too.

## Complex configuration

By default the Railtie will wrap the standard Rails logger. If you want to
utilize some of the more advanced functionality of Hatchet it is recommended
that you place your configuration into `config/initializers/hatchet.rb`.

Before specifying your [custom configuration](/hatchet/configuration.html) you
may want to reset Hatchet in order to remove the Rails logger from its
configuration:

{% highlight ruby %}
Hatchet.configure do |config|
  # Remove any existing configuration
  config.reset!
  # Then specify your custom configuration
end
{% endhighlight %}

