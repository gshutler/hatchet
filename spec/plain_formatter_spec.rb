# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe PlainFormatter do
  let(:subject) { PlainFormatter.new }

  describe 'when formatting a message' do

    describe 'without an error' do

      before do
        @message = Message.new([], '  Hello, World  ')
      end

      it 'outputs the message in the MESSAGE format' do
        message = subject.format(:info, 'Custom::Context', @message)
        assert '  Hello, World  ' == message, "got #{message}"
      end

    end

    describe 'with an error' do

      before do
        error = OpenStruct.new(message: 'Boom!', backtrace: ['foo.rb:1:a', 'foo.rb:20:b'])
        @message = Message.new([], '  Hello, World  ', error)
      end

      describe 'with backtraces enabled' do

        it 'outputs the message in the MESSAGE format' do
          message = subject.format(:info, 'Custom::Context', @message)
          assert_equal %q{  Hello, World  
    foo.rb:1:a
    foo.rb:20:b}, message
        end

      end

      describe 'with backtraces disabled' do

        before do
          subject.backtrace = false
        end

        it 'outputs the message in the MESSAGE format' do
          message = subject.format(:info, 'Custom::Context', @message)
          assert '  Hello, World  ' == message, "got #{message}"
        end

      end

    end

  end

end

