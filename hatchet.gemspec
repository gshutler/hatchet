# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hatchet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Garry Shutler"]
  gem.email         = ["garry@robustsoftware.co.uk"]
  gem.description   = %q{Logging library that provides the ability to add class/module specific filters}
  gem.summary       = %q{Logging library that provides the ability to add class/module specific filters}
  gem.homepage      = "https://github.com/gshutler/hatchet"

  gem.files         = Dir['{lib,spec}/**/*'] + %w{LICENSE}
  gem.test_files    = Dir['spec/**/*']
  gem.name          = "hatchet"
  gem.require_paths = ["lib"]
  gem.version       = Hatchet::VERSION
end
