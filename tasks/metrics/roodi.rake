# encoding: utf-8

begin
  require 'roodi'
  require 'rake/tasklib'
  require 'roodi_task'

  project = Devtools.project

  namespace :metrics do
    RoodiTask.new do |t|
      t.verbose  = false
      t.config   = project.roodi.config_file
      t.patterns = [ project.file_pattern ]
    end
  end
rescue LoadError
  task :roodi do
    $stderr.puts 'Roodi is not available. In order to run roodi, you must: gem install roodi'
  end
end
