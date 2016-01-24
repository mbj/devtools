namespace :metrics do
  desc 'Measure code complexity'
  task :flog do
    config = Devtools.project.flog

    Devtools::Rake::Flog.call(
      threshold: config.threshold.to_f.round(1),
      lib_dirs:  config.lib_dirs
    )
  end
end
