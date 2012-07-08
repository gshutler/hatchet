# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe LoggerAppender do
  let(:logger)    { LoggerDouble.new }
  let(:formatter) { SimpleFormatter.new }
  let(:subject) do
    LoggerAppender.new do |appender|
      appender.logger    = logger
      appender.formatter = formatter
      appender.levels    = { nil => :info }
    end
  end

  describe 'creating an appender' do
    before { subject }

    it 'removes filtering from the interal logger' do
      assert_equal ::Logger::DEBUG, logger.level
    end

    it 'sets a formatter that returns the message with a trailing linebreak' do
      msg = 'Plain message'
      formatted_message = logger.formatter.call('sev', Time.now, 'prog', msg)
      assert_equal "#{msg}\n", formatted_message
    end
  end

  describe 'sending a message for a disabled level' do
    it 'does not pass the message on to the logger' do
      subject.add :debug, 'Context', 'Hello, World'
      assert_empty logger.messages
    end
  end

  describe 'sending a message of an enabled level' do
    let(:message) { logger.messages.last }

    it 'passes the message on to the logger' do
      subject.add :info, 'Context', 'Hello, World'

      assert :info,          message.level
      assert 'Context',      message.context
      assert 'Hello, World', message.message
    end
  end
end

