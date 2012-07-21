---
layout: default
title: Hatchet - Sinatra Installation
---

# Sinatra Installation

## Bundler-Enabled Applications

Add this line to your application's Gemfile to get Hatchet from
[RubyGems.org](https://rubygems.org/gems/hatchet):

{% highlight ruby %}
gem 'hatchet'
{% endhighlight %}

And then execute:

    $ bundle

If you are using Bundler to require your gems then Hatchet should now be
available. Otherwise, you will need to require the Hatchet gem explicitly:

{% highlight ruby %}
require 'hatchet'
{% endhighlight %}

 * [Helper Registration](#helper_registration)
 * [Configuration](#configuration)

## Non-Bundler Applications

First you must install the gem from
[RubyGems.org](https://rubygems.org/gems/hatchet):

    $ gem install hatchet

Then you must require the gem from with your application:

{% highlight ruby %}
require 'hatchet'
{% endhighlight %}

 * [Helper Registration](#helper_registration)
 * [Configuration](#configuration)

## Helper Registration

Hatchet comes with the hook required to add itself as a helper. Once you have
required the Hatchet gem you can register Hatchet as a helper:

{% highlight ruby %}
register Hatchet
{% endhighlight %}

Alternatively, if you are using a class-based style of application you can
include it in the individual classes:

{% highlight ruby %}
class MyApp < Sinatra::Base
  include Hatchet
end
{% endhighlight %}

# Configuration

Configuration is done via the
[standard configuration mechanism](/hatchet/configuration.html). Where this is
done depends on how you have laid out your application but you should ensure
that Hatchet is configured before you try and use it to log messages.

