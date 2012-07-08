# -*- encoding: utf-8 -*-

require_relative 'spec_helper'
require 'ostruct'

describe Hatchet::Logger do
  ALL_LEVELS = [:debug, :info, :warn, :error, :fatal]

  let(:appender)  { StoringAppender.new :debug }
  let(:appenders) { [appender] }
  let(:context)   { Context::Class.new }
  let(:subject)   { Hatchet::Logger.new context, appenders }

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

INITIAL_EXECUTION_CONTEXT = self

class StoringAppender
  include LevelManager

  attr_reader :messages

  def initialize(default_level)
    @messages = []
    @levels = { nil => default_level }
  end

  def add(level, context, message)
    @messages << OpenStruct.new(level: level, context: context, message: message)
  end
end

module Context
  class Class ; end
end

