namespace :metrics do
  config = Devtools.project.mutant

  desc 'Measure mutation coverage'
  task mutant: :coverage do
    Devtools::Rake::Mutant.call(config)
  end
end
