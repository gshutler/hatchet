# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe HatchetLogger do
  let(:disabled_appender) { DisabledAppender.new }
  let(:appender)      { StoringAppender.new :debug }
  let(:appenders)     { [appender, disabled_appender] }
  let(:configuration) { Configuration.new }
  let(:context)       { Context::Class.new }
  let(:subject) do
    configuration.appenders.push(*appenders)
    HatchetLogger.new context, configuration
  end

  ALL_LEVELS.each do |level|
    describe "receiving #{level} messages" do
      let(:message) { "#{level} message" }

      it 'should store pre-evaluated messages' do
        subject.send level, message
        received = appender.messages.last

        assert level == received.level
        assert context.class == received.context
        assert message == received.message.to_s
      end

      it 'should store block messages' do
        subject.send(level) { message }
        received = appender.messages.last

        assert level == received.level
        assert context.class == received.context
        assert message == received.message.to_s
      end

      it 'should not call the disabled appender' do
        subject.send level, message

        refute disabled_appender.add_called
      end

      it 'should return nil from the call' do
        returned = subject.send(level, message)

        assert returned.nil?, 'logging calls should return nil'
      end

      describe 'with an error' do
        let(:error) { StandardError.new }

        it 'should pass the error through to the appender' do
          subject.send level, message, error
          received = appender.messages.last

          assert error == received.message.error
        end
      end
    end
  end

  describe 'responding to level checks' do
    let(:noop_appender) { StoringAppender.new :off }

    before do
      appenders << noop_appender
    end

    ALL_LEVELS.each do |level|
      it "responds to #{level} as one of the appenders does" do
        assert subject.send "#{level}?"
      end
    end

    describe 'with no appenders responding to debug' do
      before do
        appenders.clear
        appenders << StoringAppender.new(:info)
        appenders << StoringAppender.new(:warn)
      end

      it 'does not respond to debug' do
        refute subject.debug?
      end

      it 'does respond to info' do
        assert subject.info?
      end
    end
  end

  describe 'empty messages' do
    it 'not passed on to appender' do
      subject.fatal

      assert_empty appender.messages
    end
  end

  describe 'failing appender' do
    before do
      configuration.appenders << FailingAppender.new
    end

    it 'does not fail' do
      subject.info 'Will fail for one appender'
    end
  end

  describe 'naming context' do
    let(:context_name) do
      subject.fatal 'Message'
      # Get the context passed to the appender.
      appender.messages.last.context.to_s
    end

    describe 'for instances of a class' do
      let(:context) { Context::Class.new }

      it 'reports class name' do
        assert_equal 'Context::Class', context_name
      end
    end

    describe 'for modules' do
      let(:context) { Context }

      it 'reports module name' do
        assert_equal 'Context', context_name
      end
    end

    describe 'for the initial execution context of Ruby' do
      let(:context) { INITIAL_EXECUTION_CONTEXT }

      it 'reports "main"' do
        assert_equal 'main', context_name
      end
    end
  end
end

