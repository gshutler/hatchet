# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe StructuredFormatter do
  UTC_TIME_FORMAT = '%Y-%m-%d %H:%M:%S.%LZ'

  let(:subject) { StructuredFormatter.new }

  describe 'when formatting a message' do
    before do
      ndc = NestedDiagnosticContext::ContextStack.new([:foo, 12])
      @message = Message.new(ndc: ndc, message: 'Hello, World')
      @context = 'Custom::Context'
      @level   = :info
      @formatted_message = subject.format(@level, @context, @message)
    end

    it "encodes the message as JSON" do
      expected = {
        "timestamp" => Time.now.getutc.strftime(UTC_TIME_FORMAT),
        "level" => "INFO",
        "pid" => Process.pid.to_s,
        "context" => @context,
        "ndc" => ["foo", "12"],
        "message" => @message.to_s.strip,
      }

      assert_equal JSON.parse(@formatted_message), expected
    end

    describe 'with an error' do
      before do
        error = OpenStruct.new(message: 'Boom!', backtrace: ['foo.rb:1:a', 'foo.rb:20:b'])
        @message = Message.new(ndc: [], message: '  Hello, World  ', error: error)
      end

      it 'encodes the error' do
        expected = {
          "timestamp" => Time.now.getutc.strftime(UTC_TIME_FORMAT),
          "level" => "INFO",
          "pid" => Process.pid.to_s,
          "context" => @context,
          "message" => @message.to_s.strip,
          "error" => {
            "class" => "OpenStruct",
            "message" => "Boom!",
            "backtrace" => @message.error.backtrace,
          },
        }

        formatted_message = subject.format(@level, @context, @message)

        assert_equal JSON.parse(formatted_message), expected
      end
    end
  end
end
