namespace :metrics do
  require 'flay'

  config  = Devtools.project.flay

  # Original code by Marty Andrews:
  # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
  desc 'Measure code duplication'
  task :flay do
    Devtools::Rake::Flay.call(config)
  end
end
