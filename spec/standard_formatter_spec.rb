# -*- encoding: utf-8 -*-

require_relative 'spec_helper'
require 'date'

describe StandardFormatter do
  TIME_FORMAT = '%Y-%m-%d %H:%M:%S.%L'

  let(:subject) { StandardFormatter.new }

  describe 'when formatting a message' do
    before do
      @message = 'Hello, World'
      @context = 'Custom::Context'
      @level   = :info
      @formatted_message = subject.format(@level, @context, @message)
    end

    it 'outputs the timestamp in %Y-%m-%d %H:%M:%S.%L format' do
      # Dear god parsing times in Ruby is a pain so create a correctly formatted
      # string then parse them both to compare them, otherwise timezones get
      # crazy.
      expected = to_time format_as_string(Time.now)
      actual   = to_time @formatted_message
      diff     = expected - actual

      assert diff >= 0,  'must be no later expected'
      assert diff <= 50, 'must be very recent'
    end

    it 'outputs the pid when run in the main thread' do
      assert_equal Process.pid.to_s, thread_name
    end

    it 'converts the level to uppercase' do
      assert_includes @formatted_message, @level.to_s.upcase
    end

    it 'formats the message after the time as expected' do
      expected = "[#{Process.pid}] #{@level.to_s.upcase.ljust 5} #{@context} - #{@message}"
      actual_without_time = @formatted_message[24..-1]

      assert_equal expected, actual_without_time
    end

    describe 'when running in a thread' do
      before do
        @thread = Thread.new { subject.format(:info, @context, @message) }
        @formatted_message = @thread.value
      end

      it 'outputs the pid and the thread object_id' do
        assert_equal "#{Process.pid}##{@thread.object_id}", thread_name
      end
    end

    if ENV["BENCH"] then

      describe 'benchmarks' do
        it 'is reasonably quick' do
          start = Time.now

          50_000.times do
            subject.format(:info, @context, @message)
          end

          took = Time.now - start
          limit = 0.4
          assert took < limit, "Expected messages to take less than #{limit} but took #{took}"
        end
      end

    end

    def format_as_string(time)
      time.strftime TIME_FORMAT
    end

    def to_time(string)
      DateTime.strptime string[0..23], TIME_FORMAT
    end

    def thread_name
      match = /\[([^\]]+)\]/.match(@formatted_message)
      match[1]
    end
  end

end
