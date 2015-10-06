# encoding: utf-8

namespace :metrics do
  require 'flay'

  project = Devtools.project
  config  = project.flay

  # Original code by Marty Andrews:
  # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
  desc 'Measure code duplication'
  task :flay do
    threshold   = config.threshold
    total_score = config.total_score
    files       = Flay.expand_dirs_to_files(config.lib_dirs).sort

    Devtools::Rake::Flay.call(
      threshold:   threshold,
      total_score: total_score,
      files:       files
    )
  end
end
