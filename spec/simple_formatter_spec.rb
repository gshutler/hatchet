# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe SimpleFormatter do
  let(:subject) { SimpleFormatter.new }

  describe 'when formatting a message' do

    describe 'without an error' do

      before do
        @message = Message.new(ndc: [], message: '  Hello, World  ')
      end

      it 'outputs the message in the LEVEL - CONTEXT - MESSAGE format' do
        message = subject.format(:info, 'Custom::Context', @message)
        assert 'INFO - Custom::Context - Hello, World' == message, "got #{message}"
      end

    end

    describe 'with an error' do

      before do
        error = OpenStruct.new(message: 'Boom!', backtrace: ['foo.rb:1:a', 'foo.rb:20:b'])
        @message = Message.new(ndc: [], message: '  Hello, World  ', error: error)
      end

      describe 'with backtraces enabled' do

        it 'outputs the message in the LEVEL - CONTEXT - MESSAGE format' do
          message = subject.format(:info, 'Custom::Context', @message)
          assert_equal %q{INFO - Custom::Context - Hello, World
    foo.rb:1:a
    foo.rb:20:b}, message
        end

      end

      describe 'with backtraces disabled' do

        before do
          subject.backtrace = false
        end

        it 'outputs the message in the LEVEL - CONTEXT - MESSAGE format' do
          message = subject.format(:info, 'Custom::Context', @message)
          assert 'INFO - Custom::Context - Hello, World' == message, "got #{message}"
        end

      end

    end

    describe 'with thread context' do

      before do
        subject.thread_context = true
        @message = Message.new(ndc: [], message: '  Hello, World  ')
      end

      it 'outputs the message in the [THREAD] - LEVEL - CONTEXT - MESSAGE format' do
        message = subject.format(:info, 'Custom::Context', @message)
        assert "[#{Process.pid}] - INFO - Custom::Context - Hello, World" == message, "got #{message}"
      end

    end

    describe 'with ndc' do

      before do
        @message = Message.new(ndc: [:foo, 123], message: '  Hello, World  ')
      end

      it 'outputs the message in the [THREAD] - LEVEL - CONTEXT NDC - MESSAGE format' do
        message = subject.format(:info, 'Custom::Context', @message)
        assert "INFO - Custom::Context foo 123 - Hello, World" == message, "got #{message}"
      end

    end

  end

end

