# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe StructuredFormatter do
  let(:subject) { StructuredFormatter.new }

  describe 'when formatting a message' do
    let(:log_message) { 'Hello, World' }

    before do
      ndc = NestedDiagnosticContext::ContextStack.new([:foo, 12])
      @message = Message.new(ndc: ndc, message: log_message)
      @context = 'Custom::Context'
      @level   = :info
      @formatted_message = subject.format(@level, @context, @message)
    end

    it "encodes the message as JSON" do
      expected = {
        "timestamp" => Time.now.getutc.strftime(TIME_FORMAT),
        "level" => "INFO",
        "pid" => Process.pid,
        "context" => @context,
        "ndc" => ["foo", 12],
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
          "timestamp" => Time.now.getutc.strftime(TIME_FORMAT),
          "level" => "INFO",
          "pid" => Process.pid,
          "context" => @context,
          "message" => @message.to_s.strip,
          "error_class" => "OpenStruct",
          "error_message" => "Boom!",
          "error_backtrace" => @message.error.backtrace.join("\n"),
        }

        formatted_message = subject.format(@level, @context, @message)

        assert_equal JSON.parse(formatted_message), expected
      end
    end

    describe 'with a structured message' do
      let(:log_message) do
        {
          :message => "Hi, there",
          :other => 123,
        }
      end

      it "encodes the message as JSON" do
        expected = {
          "timestamp" => Time.now.getutc.strftime(TIME_FORMAT),
          "level" => "INFO",
          "pid" => Process.pid,
          "context" => @context,
          "ndc" => ["foo", 12],
          "message" => log_message[:message],
          "other" => log_message[:other],
        }

        assert_equal JSON.parse(@formatted_message), expected
      end
    end
  end
end
