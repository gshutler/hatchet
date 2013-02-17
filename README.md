# Hatchet

Ruby logging library that provides the ability to add class/module specific
filters.

This README provides a brief overview of Hatchet, [see the main site for more complete documentation and tutorials](http://gshutler.github.com/hatchet/).

[![Build Status](https://secure.travis-ci.org/gshutler/hatchet.png?branch=master)](http://travis-ci.org/gshutler/hatchet)
[![Code Climate](https://codeclimate.com/github/gshutler/hatchet.png)](https://codeclimate.com/github/gshutler/hatchet)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hatchet'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install hatchet
```

## Usage

### Logging

To use the logger you must add it to your classes as a mixin or use it to extend
your modules. Then you can call the logger through the methods `log` and
`logger`. They are aliases for the same method to ease migration.

#### Classes

```ruby
class Foo
  include Hatchet

  def self.class_work
    log.info { 'Doing some class work' }
  end

  def work
    log.info { 'Doing some work' }
  end

  def dangerous_work
    log.info { 'Attempting dangerous work' }
    attempt_dangerous_work
    log.info { 'Dangerous work complete' }
    true
  rescue => e
    log.error "Dangerous work failed - #{e.message}", e
    false
  end
end
```

#### Modules

```ruby
module Bar
  include Hatchet

  def self.work
    log.info { 'Doing some module work' }
  end

  def work
    log.info { 'Doing some mixin work' }
  end
end
```

### Configuration

#### Standard

```ruby
Hatchet.configure do |config|
  # Set the level to use unless overridden (defaults to :info)
  config.level :info
  # Set the level for a specific class/module and its children
  config.level :debug, 'Namespace::Something::Nested'

  # Add as many appenders as you like
  config.appenders << Hatchet::LoggerAppender.new do |appender|
    # Set the logger that this is wrapping (required)
    appender.logger = Logger.new('log/test.log')
  end
end
```

#### Sinatra

Use the standard configuration method but also register Hatchet as a helper
where appropriate:

```ruby
register Hatchet
```

Note that you may have to use the `log` alias as Sinatra already has a `logger`
method.

#### Rails

Hatchet includes a Railtie that is loaded automatically and wraps the
`Rails.logger`. The Hatchet configuration object is available through
`config.hatchet` within your standard configuration files for fine-tuning your
Hatchet configuration.

To make it so your log calls are scoped to your controllers you also need to add
Hatchet to your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  include Hatchet
end
```

You could include it in your models so that each of those has its own logging
context too.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

All pull requests should come complete with tests when appropriate and should
follow the existing style which is best described in
[Github's Ruby style guide](https://github.com/styleguide/ruby/).

