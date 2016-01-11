# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe LoggerAppender do
  let(:logger_double) { LoggerDouble.new }
  let(:formatter) { TestFormatter.new }
  let(:subject) do
    LoggerAppender.new do |appender|
      appender.logger    = logger_double
      appender.formatter = formatter
      appender.levels    = { nil => :info }
    end
  end

  describe 'creating an appender' do
    before { subject }

    it 'removes filtering from the interal logger' do
      assert_equal ::Logger::DEBUG, logger_double.level
    end

    it 'sets a formatter that returns the message with a trailing linebreak' do
      msg = 'Plain message'
      formatted_message = logger_double.formatter.call('sev', Time.now, 'prog', msg)
      assert_equal "#{msg}\n", formatted_message
    end
  end

  describe 'sending a message of an enabled level' do
    let(:last_message) { logger_double.messages.last }

    it 'passes the message on to the logger' do
      subject.add :info, 'Context', 'Hello, World'

      assert :info,          last_message.level
      assert 'Context',      last_message.context
      assert 'Hello, World', last_message.message
    end
  end
end

