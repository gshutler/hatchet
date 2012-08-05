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

    describe 'lowering the threshold for a specific context' do
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

    describe 'raising the threshold for a specific context' do
      before do
        @manager.level :fatal, 'Foo::Bar'
      end

      it 'has info messages disabled for that context' do
        refute @manager.enabled?(:info, 'Foo::Bar')
      end

      it 'has fatal message enabled for that context' do
        assert @manager.enabled?(:fatal, 'Foo')
      end

      it 'has info messages disabled for a child context' do
        refute @manager.enabled?(:info, 'Foo::Bar::Baz')
      end

      it 'has info message enabled for the parent context' do
        assert @manager.enabled?(:info, 'Foo')
      end
    end

    describe 'altering the default level' do
      it 'alters the enabled level for subsequent calls' do
        assert @manager.enabled?(:info, 'Foo::Bar')
        @manager.level :fatal
        refute @manager.enabled?(:info, 'Foo::Bar')
      end
    end
  end
end

