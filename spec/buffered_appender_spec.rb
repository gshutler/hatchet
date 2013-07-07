# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe Hatchet::BufferedAppender do
  let(:appender)          { StoringAppender.new :debug }
  let(:buffered_appender) { BufferedAppender.new(appender) }

  let(:configuration) { Configuration.new }
  let(:context)       { Context::Class.new }
  let(:ndc)           { NestedDiagnosticContext.new }

  def messages
    appender.messages
  end

  let(:subject) do
    configuration.appenders.push(buffered_appender)
    HatchetLogger.new context, configuration, ndc
  end

  describe 'buffering messages' do

    it 'should send nothing to the underlying appender pre-flush' do
      subject.info 'should be buffered'
      assert messages.empty?
    end

    it 'should send all messages to the underlying appender post-flush' do
      subject.info 'one'
      subject.info 'two'

      assert messages.empty?

      subject.flush!

      assert messages.size == 2
      assert messages[0].message.to_s == 'one'
      assert messages[1].message.to_s == 'two'
    end

  end

end

