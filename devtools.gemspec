# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'devtools'
  gem.version     = '0.0.2'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schirp-dso.com' ]
  gem.description = 'A metagem for ROM-style development'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/rom-rb/devtools'
  gem.license     = 'MIT'

  gem.require_paths         = %w[lib]
  gem.files                 = `git ls-files`.split($/)
  gem.executables           = %w[devtools]
  gem.test_files            = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files      = %w[README.md TODO]
  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'rspec',        '~> 3.1.0'
  gem.add_dependency 'rspec-core',   '~> 3.1.7'
  gem.add_dependency 'rspec-its',    '~> 1.1.0'
  gem.add_dependency 'rake',         '~> 10.4.0'
  gem.add_dependency 'yard',         '~> 0.8.7.6'
  gem.add_dependency 'coveralls',    '~> 0.7.2'
  gem.add_dependency 'flay',         '~> 2.5.0'
  gem.add_dependency 'flog',         '~> 4.3.0'
  gem.add_dependency 'reek',         '=  1.4.0'  # locked due to buggy ast processing
  gem.add_dependency 'rubocop',      '~> 0.28.0'
  gem.add_dependency 'simplecov',    '~> 0.9.1'
  gem.add_dependency 'yardstick',    '~> 0.9.9'
  gem.add_dependency 'mutant',       '~> 0.7.4'
  gem.add_dependency 'mutant-rspec', '~> 0.7.4'
end
