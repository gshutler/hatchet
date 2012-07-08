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

### Configuration

```ruby
Hatchet.configure do |config|
  # Set the level to use unless overridden (defaults to :info)
  config.level :info
  # Set the level for a specific class/module and its children (can be a string)
  config.level :debug, Namespace::Something::Nested

  # Add as many appenders as you like, Hatchet comes with one that formats the
  # standard logger in the TTCC style of log4j.
  config.appenders << LoggerAppender.new do |appender|
    # Set the logger that this is wrapping (required)
    appender.logger = Logger.new('log/test.log')
  end
end
```

### Logging

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
