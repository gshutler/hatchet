require_relative '../lib/hatchet'
require 'logger'

module Namespace
  class Foo
    include Hatchet

    def work
      log.fatal { "Fatal! Woo!" }
    end
  end

  module Something
    extend Hatchet

    def self.work
      log.info { "Woo!" }
      logger.debug { "Debug!" }
    end

    class Nested
      include Hatchet

      def work
        log.debug { 'NESTED DEBUG' }
      end
    end
  end
end

Hatchet.configure do |config|
  config.level :warn
  config.level :debug, Namespace::Something::Nested

  config.appenders << Hatchet::LoggerAppender.new do |appender|
    appender.logger = Logger.new('log/test.log')
  end
end

include Hatchet

logger.warn 'From main'
logger.warn self.inspect

10.times do
  Thread.new { Namespace::Foo.new.work }
  Namespace::Something.work
  Thread.new { Namespace::Something::Nested.new.work }
end

sleep 0.1
