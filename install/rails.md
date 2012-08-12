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

## Configuration

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

You can also specify configuration in the standard `config/application.rb` and
the corresponding environment-specific configuration files (such as
`config/environments/production.rb`).

The Hatchet configuration is available through `config.hatchet`. If you are
setting just one property you can access it directly:

{% highlight ruby %}
config.hatchet.level :error
{% endhighlight %}

However, if you want to specify multiple values it will read better if you use
the block form:

{% highlight ruby %}
config.hatchet.configure do |hatchet|
  hatchet.level :error
  hatchet.formatter = SimpleFormatter.new
  hatchet.appenders << CustomAppender.new
end
{% endhighlight %}

## Heroku

There are some special considerations when using Hatchet with Heroku. Heroku
doesn't have a file system so [adds the `rails_log_stdout` plugin for you](https://github.com/heroku/heroku-buildpack-ruby#rails-log-stdout).
However, `rails_log_stdout` monkey patches the Rails logger meaning Hatchet
cannot hook into it as it can in normal environments.

"I don't care about the backstory, how do I get Hatchet to work with Heroku?"
I'm glad you asked.

### Stop Heroku installing rails_log_stdout

At the terminal within your application's root directory:

    $ mkdir -p vendor/plugins/rails_log_stdout
    $ touch vendor/plugins/rails_log_stdout/.gitkeep
    $ git commit -am "Prevent Heroku adding rails_log_stdout"

This stops the Heroku application packaging process from adding the
`rails_log_stdout` plugin on your behalf.

### Configure Hatchet to log to STDOUT

Add the following configuration to your `config/environments/production.rb`:

{% highlight ruby %}
config.hatchet.configure do |config|
  # Reset the logging configuration
  config.reset!
  # Use the format without time, etc so we don't duplicate it
  config.formatter = Hatchet::SimpleFormatter.new
  # Set up a STDOUT appender
  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.logger = Logger.new(STDOUT)
  end
end
{% endhighlight %}

This removes any previous configuration (such as the default Rails logger that
will to write to a file) and then adds an appender writing to STDOUT. The use of
the `SimpleFormatter` is just a suggestion, you are of course free to use any
formatter you want.

### Make STDOUT write synchronously

Usually STDOUT batches lines together when writing as it writes them out
asynchronously. This can be a bit rubbish with logs so you need to force it to
write synchronously. I usually put this into my `config.ru`:

{% highlight ruby %}
STDOUT.sync = true
{% endhighlight %}

