# Hatchet

Ruby logging library that provides the ability to add class/module specific
filters.

## Installation

Add this line to your application's Gemfile:

    gem 'hatchet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hatchet

## Usage

### Logging

To use the logger you must add it to your classes as a mixin or use it to extend
your modules. Then you can call the logger through the methods `log` and
`logger`. They are aliases for the same method to ease migration.

```ruby
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
```

### Configuration

#### Standard

```ruby
Hatchet.configure do |config|
  # Set the level to use unless overridden (defaults to :info)
  config.level :info
  # Set the level for a specific class/module and its children (can be a string)
  config.level :debug, Namespace::Something::Nested

  # Add as many appenders as you like, Hatchet comes with one that formats the
  # standard logger in the TTCC style of log4j.
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

#### Rails

***This is not great at the moment but it kind of works. I'm working on it.***

You can wrap the standard Rails logger using an initializer for your
configuration. Name the file `_hatchet.rb` so that it is run before any other
initializers that might reference the Rails logger.

```ruby
# config/initializers/_hatchet.rb

Hatchet.configure do |config|
  config.appenders << Hatchet::LoggerAppender.new(logger: Rails.logger)
end

YourApplication.extend Hatchet

Rails.logger = YourApplication.logger
```

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
