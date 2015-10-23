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

    Devtools::Rake::Flay.call(
      threshold:   threshold,
      total_score: total_score,
      lib_dirs:    config.lib_dirs,
      excludes:    config.excludes
    )
  end
end
