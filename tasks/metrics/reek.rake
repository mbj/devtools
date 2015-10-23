namespace :metrics do
  require 'reek/rake/task'

  Reek::Rake::Task.new do |reek|
    reek.source_files = '{app,lib}/**/*.rb'
    reek.config_file  = 'config/reek.yml'
  end
end
