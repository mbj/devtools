#encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'devtools'
  gem.version     = '0.0.1'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@seonic.net' ]
  gem.description = 'A metagem for dm-2 style development'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/devtools'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec`.split("\n")
  gem.extra_rdoc_files = %w[TODO]

  gem.add_runtime_dependency('adamantium', '~> 0.0.3')
end
