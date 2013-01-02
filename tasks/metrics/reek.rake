# encoding: utf-8

begin
  require 'reek/rake/task'

  namespace :metrics do
    Reek::Rake::Task.new
  end
rescue LoadError
  namespace :metrics do
    task :reek do
      $stderr.puts 'Reek is not available. In order to run reek, you must: gem install reek'
    end
  end
end
