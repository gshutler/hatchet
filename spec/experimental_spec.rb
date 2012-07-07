require_relative '../lib/lumberjack'

module Namespace

  class Foo
    include Lumberjack

    def work
      log.fatal { "Fatal! Woo!" }
    end

  end

  module Something
    extend Lumberjack

    def self.work
      log.info { "Woo!" }
      log.debug { "Debug!" }
    end

    class Nested
      include Lumberjack

      def work
        log.debug { 'NESTED DEBUG' }
      end

    end

  end

end

include Lumberjack

10.times do
  Thread.new { Namespace::Foo.new.work }
  Thread.new { Namespace::Something.work }
  Thread.new { Namespace::Something::Nested.new.work }
end

sleep 2
