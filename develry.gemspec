# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'develry'
  gem.version     = '0.0.2'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schirp-dso.com' ]
  gem.description = 'A metagem for ROM-style development'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/rom-rb/develry'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.executables      = %w[develry]
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md TODO]

  gem.add_dependency 'rake',  '~> 10.1.0'
  gem.add_dependency 'rspec', '~> 2.14.1'
  gem.add_dependency 'yard',  '~> 0.8.7'
  gem.add_dependency 'kramdown', '~> 1.2.0'

  # guard
  gem.add_dependency 'guard',         '~> 1.8.1'
  gem.add_dependency 'guard-bundler', '~> 1.0.0'
  gem.add_dependency 'guard-rspec',   '~> 3.0.2'
  gem.add_dependency 'guard-rubocop', '~> 0.2.0'
  gem.add_dependency 'guard-mutant',  '~> 0.0.1'

  # file system change event handling
  gem.add_dependency 'listen',     '~> 1.3.0'
  gem.add_dependency 'rb-fchange', '~> 0.0.6'
  gem.add_dependency 'rb-fsevent', '~> 0.9.3'
  gem.add_dependency 'rb-inotify', '~> 0.9.0'

  # notification handling
  gem.add_dependency 'libnotify',               '~> 0.8.0'
  gem.add_dependency 'rb-notifu',               '~> 0.0.4'
  gem.add_dependency 'terminal-notifier-guard', '~> 1.5.3'

  # metrics
  gem.add_dependency 'coveralls', '~> 0.6.7'
  gem.add_dependency 'flay',      '~> 2.4.0'
  gem.add_dependency 'flog',      '~> 4.1.1'
  gem.add_dependency 'reek',      '~> 1.3.2'
  gem.add_dependency 'rubocop',   '~> 0.13.0'
  gem.add_dependency 'simplecov', '~> 0.7.1'
  gem.add_dependency 'yardstick', '~> 0.9.7'

  gem.add_dependency 'mutant',          '~> 0.3.0.rc3'
  gem.add_dependency 'yard-spellcheck', '~> 0.1.5'
end
