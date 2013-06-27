# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'devtools'
  gem.version     = '0.0.2'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schir-dso.com' ]
  gem.description = 'A metagem for dm-2 style development'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/rom-rb/devtools'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md TODO]

  gem.add_dependency 'ice_nine', '~> 0.8.0'
end
