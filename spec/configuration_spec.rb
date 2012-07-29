# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe 'configuration' do
  before do
    Hatchet.configure do |config|
      config.reset!
    end
  end

  describe 'appender defaults' do
    let(:set_levels) { { unique: :fake_level } }
    let(:appender)   { StoringAppender.new }

    before do
      Hatchet.configure do |config|
        config.levels = set_levels
        config.appenders << appender
      end
    end

    it 'global levels when not explicitly set' do
      assert set_levels == appender.levels
    end

    it 'formatter set as a StandardFormatter' do
      assert appender.formatter.instance_of? DelegatingFormatter
      assert appender.formatter.formatter.instance_of? StandardFormatter
    end

    describe 'with an explicit default formatter' do
      let(:formatter) { SimpleFormatter.new }
      let(:second_appender)   { StoringAppender.new }

      before do
        Hatchet.configure do |config|
          config.formatter = formatter
          config.appenders << second_appender
        end
      end

      it 'original formatter set as the configured default' do
        assert appender.formatter.instance_of? DelegatingFormatter
        assert appender.formatter.formatter == formatter
      end

      it 'second formatter set as the configured default' do
        assert appender.formatter.instance_of? DelegatingFormatter
        assert second_appender.formatter.formatter == formatter
      end
    end
  end

  describe 'appender overrides' do
    let(:default_levels)     { { unique: :fake_level } }
    let(:appender_levels)    { { appender: :faker_level } }
    let(:appender_formatter) { TestFormatter.new }
    let(:appender) do
      StoringAppender.new do |app|
        app.levels    = appender_levels
        app.formatter = appender_formatter
      end
    end

    before do
      Hatchet.configure do |config|
        config.levels = default_levels
        config.appenders << appender
      end
    end

    it 'keeps the levels assigned to the appender' do
      assert appender.levels == appender_levels
    end

    it 'keeps the formatter assigned to the appender' do
      assert appender.formatter == appender_formatter
    end
  end

  describe 'global default level' do
    let(:appender) { StoringAppender.new }

    before do
      Hatchet.configure do |config|
        config.appenders << appender
      end
    end

    it 'set to info' do
      assert appender.levels[nil] == :info
    end
  end

  describe 'everything wires up' do
    let(:appender) { StoringAppender.new }

    before do
      Hatchet.configure do |config|
        config.appenders << appender
      end
    end

    class Example
      include Hatchet

      def initialize
        log.info { 'Creating instance' }
      end
    end

    it 'should log a message when creating an instance' do
      Example.new
      msg = appender.messages.last

      assert_equal :info,   msg.level
      assert_equal Example, msg.context
      assert_equal 'Creating instance', msg.message.to_s
    end
  end
end

