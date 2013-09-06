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
end

