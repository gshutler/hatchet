# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

class IncludeExample
  include Hatchet

  def self.class_log
    log.info { 'class log' }
  end

  def instance_log
    log.info { 'instance log' }
  end

end

describe 'hatchet include behavior' do
  let(:appender) { StoringAppender.new }

  before do
    Hatchet.configure do |config|
      config.reset!
      config.appenders << appender
    end
  end

  describe 'logging from class methods' do
    before do
      IncludeExample.class_log
    end

    it 'logs a method from the class' do
      msg = appender.messages.last

      assert_equal :info,   msg.level
      assert_equal IncludeExample, msg.context
      assert_equal 'class log', msg.message.to_s
    end
  end

  describe 'logging from instance methods' do
    before do
      IncludeExample.new.instance_log
    end

    it 'logs a method from the instance' do
      msg = appender.messages.last

      assert_equal :info,   msg.level
      assert_equal IncludeExample, msg.context
      assert_equal 'instance log', msg.message.to_s
    end
  end
end

