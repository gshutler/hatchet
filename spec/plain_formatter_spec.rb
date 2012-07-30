# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe PlainFormatter do
  let(:subject) { PlainFormatter.new }

  describe 'when formatting a message' do
    before do
      @message = subject.format(:info, 'Custom::Context', '  Hello, World  ')
    end

    it 'outputs the message in the MESSAGE format' do
      assert '  Hello, World  ' == @message, "got #{@message}"
    end
  end
end

