require_relative 'spec_helper'

describe Middleware do

  class App
    include Hatchet

    def initialize
      @request = 1
    end

    def call(env)
      log.ndc.push(@request)

      log.info "Start"

      one = One.new
      one.run(env)

      log.ndc.push(:end)
      log.info "Finish"

      @request += 1

      [:status, :headers, :body]
    end

    class One
      include Hatchet

      def run(env)
        log.ndc.push(:one)
        log.info env[:one]
      end
    end

  end

  let(:storing_appender) { StoringAppender.new :debug }
  let(:messages) { storing_appender.messages }

  let(:subject) do
    Hatchet.configure do |config|
      config.reset!
      config.appenders << storing_appender
    end

    app = App.new
    Middleware.new(app)
  end

  before do
    messages.clear
  end

  describe "maintaining the result" do

    before do
      @status, @headers, @body = subject.call(one: 'Testing')
    end

    it "maintains the status" do
      assert_equal :status, @status
    end

    it "maintains the headers" do
      assert_equal :headers, @headers
    end

    it "maintains the body" do
      assert_equal :body, @body
    end

  end

  describe "accumulating context" do

    before do
      subject.call(one: 'Testing')
    end

    it "logs accumulating context" do
      assert_equal "Start", messages[0].message.to_s
      assert_equal [1], messages[0].message.ndc.stack

      assert_equal 'Testing', messages[1].message.to_s
      assert_equal [1, :one], messages[1].message.ndc.stack

      assert_equal 'Finish', messages[2].message.to_s
      assert_equal [1, :one, :end], messages[2].message.ndc.stack
    end

  end

  describe "clearing context between requests" do

    before do
      subject.call(one: 'Testing')
      subject.call(one: 'TestingAgain')
    end

    it "clears context from previous requests" do
      assert_equal "Start", messages[3].message.to_s
      assert_equal [2], messages[3].message.ndc.stack

      assert_equal 'TestingAgain', messages[4].message.to_s
      assert_equal [2, :one], messages[4].message.ndc.stack

      assert_equal 'Finish', messages[5].message.to_s
      assert_equal [2, :one, :end], messages[5].message.ndc.stack
    end

  end

end
