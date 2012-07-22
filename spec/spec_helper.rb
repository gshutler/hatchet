# -*- encoding: utf-8 -*-

require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/hatchet'

# Avoid having to refer to everything absolutely all the time.
include Hatchet

require_relative 'helpers/logger_double'
require_relative 'helpers/test_formatter'
require_relative 'helpers/disabled_appender'
require_relative 'helpers/storing_appender'

INITIAL_EXECUTION_CONTEXT = self

ALL_LEVELS = [:debug, :info, :warn, :error, :fatal]

module Context
  class Class ; end
end

