# encoding: utf-8

namespace :metrics do
  require 'reek/rake/task'

  project = Devtools.project
  config  = project.reek

  if config.enabled?
    Reek::Rake::Task.new do |reek|
      reek.source_files = '{app,lib}/**/*.rb'
      reek.config_file  = 'config/reek.yml'
    end
  else
    task :reek do
      $stderr.puts 'Reek is disabled'
    end
  end
end
