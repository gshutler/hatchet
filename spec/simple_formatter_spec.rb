# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe SimpleFormatter do
  let(:subject) { SimpleFormatter.new }

  describe 'when formatting a message' do
    before do
      @message = subject.format(:info, 'Custom::Context', 'Hello, World')
    end

    it 'outputs the message in the LEVEL - CONTEXT - MESSAGE format' do
      assert 'INFO - Custom::Context - Hello, World' == @message, "got #{@message}"
    end
  end
end

