Gem::Specification.new do |gem|
  gem.name        = 'devtools'
  gem.version     = '0.1.16'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schirp-dso.com' ]
  gem.description = 'A metagem wrapping development tools'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/rom-rb/devtools'
  gem.license     = 'MIT'

  gem.require_paths         = %w[lib]
  gem.files                 = `git ls-files`.split($/)
  gem.executables           = %w[]
  gem.test_files            = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files      = %w[README.md]
  gem.required_ruby_version = '>= 2.1'

  gem.add_runtime_dependency 'procto',       '~> 0.0.3'
  gem.add_runtime_dependency 'anima',        '~> 0.3.0'
  gem.add_runtime_dependency 'concord',      '~> 0.1.5'
  gem.add_runtime_dependency 'adamantium',   '~> 0.2.0'
  gem.add_runtime_dependency 'rspec',        '~> 3.5.0'
  gem.add_runtime_dependency 'rspec-core',   '~> 3.5.4'
  gem.add_runtime_dependency 'rspec-its',    '~> 1.2.0'
  gem.add_runtime_dependency 'rake',         '~> 12.0.0'
  gem.add_runtime_dependency 'yard',         '~> 0.9.1'
  gem.add_runtime_dependency 'flay',         '~> 2.8.1'
  gem.add_runtime_dependency 'flog',         '~> 4.4.0'
  gem.add_runtime_dependency 'reek',         '~> 4.5.0'
  gem.add_runtime_dependency 'rubocop',      '~> 0.47.0'
  gem.add_runtime_dependency 'simplecov',    '~> 0.12.0'
  gem.add_runtime_dependency 'yardstick',    '~> 0.9.9'
  gem.add_runtime_dependency 'mutant',       '~> 0.8.11'
  gem.add_runtime_dependency 'mutant-rspec', '~> 0.8.11'
end
