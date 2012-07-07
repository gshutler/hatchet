require_relative '../lib/hatchet'
require 'logger'

module Namespace
  class Foo
    include Hatchet

    def work
      log.fatal { "Fatal message will be shown" }
    end
  end

  module Something
    extend Hatchet

    def self.work
      log.info { "Info message will be shown" }
      logger.debug { "Debug message won't be shown" }
    end

    class Nested
      include Hatchet

      def work
        log.debug { "Debug message will be shown due to override" }
      end
    end
  end
end

Hatchet.configure do |config|
  config.level :info
  config.level :debug, Namespace::Something::Nested

  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.logger = Logger.new('log/test.log')
  end
end

include Hatchet

log.warn 'Warn message will be shown'
thread = Thread.new { Namespace::Foo.new.work }
Namespace::Something.work
Namespace::Something::Nested.new.work

thread.join
