# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'devtools'
  gem.version     = '0.1.0'
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
  gem.required_ruby_version = '>= 2.1'

  gem.add_dependency 'rspec',        '~> 3.3.0'
  gem.add_dependency 'rspec-core',   '~> 3.3.0'
  gem.add_dependency 'rspec-its',    '~> 1.2.0'
  gem.add_dependency 'rake',         '~> 10.4.2'
  gem.add_dependency 'yard',         '~> 0.8.7.6'
  gem.add_dependency 'flay',         '~> 2.6.1'
  gem.add_dependency 'flog',         '~> 4.3.2'
  gem.add_dependency 'reek',         '~> 3.3.1'
  gem.add_dependency 'rubocop',      '~> 0.33.0'
  gem.add_dependency 'simplecov',    '~> 0.10.0'
  gem.add_dependency 'yardstick',    '~> 0.9.9'
  gem.add_dependency 'mutant',       '~> 0.8.3'
  gem.add_dependency 'mutant-rspec', '~> 0.8.2'
end
