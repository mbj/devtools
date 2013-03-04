# encoding: utf-8

namespace :metrics do
  if Devtools.rvm == 'mri-2.0.0'
    task :reek do
      $stderr.puts "Reek::Rake::Task does not work under #{Devtools.rvm} currently and is disabled"
    end
  else
    begin
      require 'reek/rake/task'

      Reek::Rake::Task.new do |reek|
        reek.reek_opts = '--quiet'  # silence output for files with no errors
      end
    rescue LoadError
      task :reek do
        $stderr.puts 'Reek is not available. In order to run reek, you must: gem install reek'
      end
    end
  end
end
