namespace :metrics do
  require 'reek/rake/task'

  task :reek do
    config = Devtools.project.reek

    Devtools::Rake::Reek.call(
      files:  FileList['{app,lib}/**/*.rb'].to_a,
      config: config
    )
  end
end
