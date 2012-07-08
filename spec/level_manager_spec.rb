# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe LevelManager do
  before do
    @manager = Object.new
    @manager.extend LevelManager
  end

  describe 'setting a default level of info' do
    before do
      @manager.level :info
    end

    it 'has info messages enabled for any context' do
      assert @manager.enabled?(:info, 'Foo::Bar')
    end

    it 'has debug messages disabled for any context' do
      refute @manager.enabled?(:debug, 'Foo::Bar')
    end

    describe 'overriding the default for a specific context' do
      before do
        @manager.level :debug, 'Foo::Bar'
      end

      it 'has debug messages enabled for that context' do
        assert @manager.enabled?(:debug, 'Foo::Bar')
      end

      it 'has debug messages enabled for a child context' do
        assert @manager.enabled?(:debug, 'Foo::Bar::Baz')
      end

      it 'has debug message disabled for the parent context' do
        refute @manager.enabled?(:debug, 'Foo')
      end
    end
  end
end

