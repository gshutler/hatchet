require_relative '../lib/lumberjack'

module Namespace

  class Foo
    include Lumberjack

    def work
      log.fatal { "Fatal! Woo!" }
      log.info { "Woo!" }
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

2.times { log.info "WAT" }

2.times do
  Namespace::Foo.new.work
  Namespace::Something.work
  Namespace::Something::Nested.new.work
end

