---
layout: default
title: Hatchet - Standard Installation
---

# Standard Installation

## Bundler-Enabled Applications

Add this line to your application's Gemfile:

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

 * [Configuration](#configuration)

## Non-Bundler Applications

First you must install the gem:

    $ gem install hatchet

Then you must require the gem from with your application:

{% highlight ruby %}
require 'hatchet'
{% endhighlight %}

## Adding To Classes

To make Hatchet's logging method available within a class you must include the
Hatchet module:

{% highlight ruby %}
class MyClass
  include Hatchet
end
{% endhighlight %}

## Adding To Modules

To make Hatchet's logging method available within a module you must extend the
module with Hatchet:

{% highlight ruby %}
class MyModule
  extend Hatchet
end
{% endhighlight %}

## Using With Scripts

Hatchet can also be used with scripts by including the Hatchet module at the top
level:

{% highlight ruby %}
include Hatchet
{% endhighlight %}

# Configuration

Configuration is done via the
[standard configuration mechanism](/hatchet/configuration.html). Where this is
done depends on how you have laid out your application but you should ensure
that Hatchet is configured before you try and use it to log messages.

