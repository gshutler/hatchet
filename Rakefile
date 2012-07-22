#!/usr/bin/env rake

require "bundler/gem_tasks"
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |test|
  test.pattern = "spec/*_spec.rb"
end
