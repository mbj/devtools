# encoding: utf-8

namespace :metrics do
  require 'reek/rake/task'

  project = Devtools.project
  config  = project.reek

  if config.enabled?
    Reek::Rake::Task.new do |reek|
      reek.reek_opts     = '--quiet'
      reek.fail_on_error = Devtools.fail_on_metric_violation?
      reek.config_files  = config.config_file.to_s
      reek.source_files  = '{app,lib}/**/*.rb'
    end
  else
    task :reek do
      $stderr.puts 'Reek is disabled'
    end
  end
end
