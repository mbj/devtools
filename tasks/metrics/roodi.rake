# encoding: utf-8

namespace :metrics do
  begin
    require 'roodi'
    require 'rake/tasklib'
    require 'roodi_task'

    project = Devtools.project

    RoodiTask.new do |roodi|
      roodi.verbose  = false
      roodi.config   = project.roodi.config_file
      roodi.patterns = [ project.file_pattern ]
    end
  rescue LoadError
    task :roodi do
      $stderr.puts 'Roodi is not available. In order to run roodi, you must: gem install roodi'
    end
  end
end
