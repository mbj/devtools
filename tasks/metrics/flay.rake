namespace :metrics do
  desc 'Measure code duplication'
  task :flay do
    config = Devtools.project.flay

    Devtools::Rake::Flay.call(
      threshold:   config.threshold,
      total_score: config.total_score,
      lib_dirs:    config.lib_dirs,
      excludes:    config.excludes
    )
  end
end
