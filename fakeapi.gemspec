# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fakeapi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Wojciech Mach']
  gem.email         = ['wojtek@wojtekmach.pl']
  gem.description   = %q{FakeAPI o}
  gem.summary       = %q{FakeAPI}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'fakeapi'
  gem.require_paths = ['lib']
  gem.version       = FakeAPI::VERSION
end
