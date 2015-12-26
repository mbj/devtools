namespace :metrics do
  require 'reek/rake/task'

  task :reek do
    config = Devtools.project.reek

    Devtools::Rake::Reek.call(config)
  end
end
