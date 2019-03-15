# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe Message do
  describe 'providing an evaluted message that is not a string' do
    let(:subject) { Message.new(ndc: [], message: Rational(1.5)) }

    it 'returns the given message' do
      assert_equal '3/2', subject.to_s
    end
  end

  describe 'providing an evaluted message' do
    let(:subject) { Message.new(ndc: [], message: 'Evaluated') }

    it 'returns the given message' do
      assert_equal 'Evaluated', subject.to_s
    end
  end

  describe 'providing a block message that does not return a string' do
    let(:subject) do
      Message.new(ndc: []) do
        Rational(1.5)
      end
    end

    it 'returns the result of evaluating the block and calling #to_s on the result' do
      assert_equal '3/2', subject.to_s
    end
  end

  describe 'providing a block message' do
    let(:subject) do
      @evaluated = 0
      Message.new(ndc: []) do
        @evaluated += 1
        'Block'
      end
    end

    it 'returns the result of evaluating the block' do
      assert_equal 'Block', subject.to_s
    end

    it 'only evaluates the block once for multiple calls' do
      subject.to_s
      subject.to_s
      assert_equal 1, @evaluated
    end
  end

  describe 'providing both an evaluated and block message' do
    let(:subject) do
      Message.new(ndc: [], message: 'Evaluated') do
        'Block'
      end
    end

    it 'returns the result of evaluating the block' do
      assert_equal 'Block', subject.to_s
    end
  end

  describe 'supporting the old constructor format' do
    describe 'providing an evaluted message' do
      let(:subject) { Message.new('Evaluated') }

      it 'returns the given message' do
        assert_equal 'Evaluated', subject.to_s
      end
    end

    describe 'providing a block message' do
      let(:subject) do
        @evaluated = 0
        Message.new do
          @evaluated += 1
          'Block'
        end
      end

      it 'returns the result of evaluating the block' do
        assert_equal 'Block', subject.to_s
      end

      it 'only evaluates the block once for multiple calls' do
        subject.to_s
        subject.to_s
        assert_equal 1, @evaluated
      end
    end

    describe 'providing both an evaluated and block message' do
      let(:subject) do
        Message.new('Evaluated') do
          'Block'
        end
      end

      it 'returns the result of evaluating the block' do
        assert_equal 'Block', subject.to_s
      end
    end
  end

  describe 'filtering backtraces' do
    def generate_error
      raise 'Example failure'
    rescue => e
      e
    end

    let(:dirname) { File.dirname(__FILE__) }
    let(:error) { generate_error }

    let(:subject) do
      Message.new(error: generate_error, backtrace_filters: backtrace_filters)
    end

    require 'rbconfig'

    describe 'string keys' do
      let(:backtrace_filters) do
        {
          dirname => '$DIRNAME',
          RbConfig::CONFIG['rubylibdir'] => '$RUBYLIBDIR',
        }
      end

      it 'replaces the matching keys' do
        backtrace = subject.error.backtrace

        backtrace_filters.each do |prefix, replacement|
          refute backtrace.find { |line| line.start_with? prefix }, "Backtrace should not have a line starting '#{prefix}'\n\t#{backtrace.join("\n\t")}"
        end
      end
    end

    describe 'array keys' do
      let(:backtrace_filters) do
        {
          [dirname, RbConfig::CONFIG['rubylibdir']] => '$REPLACEMENT',
        }
      end

      it 'replaces the matching keys' do
        backtrace = subject.error.backtrace

        backtrace_filters.each do |prefixes, replacement|
          prefixes.each do |prefix|
            refute backtrace.find { |line| line.start_with? prefix }, "Backtrace should not have a line starting '#{prefix}'\n\t#{backtrace.join("\n\t")}"
          end
        end
      end
    end

    describe 'class' do
      let(:backtrace_filters) { Hash.new }

      it 'returns the class of the error' do
        assert_equal subject.error.class, RuntimeError
      end
    end
  end

  if ENV["BENCH"] then
    describe 'benchmarks' do
      let(:subject) { Message.new(ndc: [], message: 'Evaluated') }

      it 'invoking to_s once' do
        start = Time.now

        50_000.times do
          subject.to_s
        end

        took = Time.now - start
        puts "\nMessages took #{took} to generate\n"
      end

      it 'invoking to_s four times' do
        start = Time.now

        50_000.times do
          subject.to_s
          subject.to_s
          subject.to_s
          subject.to_s
        end

        took = Time.now - start
        puts "\nMessages took #{took} to generate\n"
      end
    end
  end
end

