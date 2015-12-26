namespace :metrics do
  require 'reek/rake/task'

  task :reek do
    config = Devtools.project.reek

    Devtools::Rake::Reek.call(
      files:  FileList[config.files].to_a,
      config: config
    )
  end
end
