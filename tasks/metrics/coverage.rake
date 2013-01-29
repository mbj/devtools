# encoding: utf-8

namespace :metrics do
  begin
    require 'simplecov'

    desc 'Generate code coverage'
    task :coverage do
      begin
        original, ENV['COVERAGE'] = ENV['COVERAGE'], 'true'
        Rake::Task['spec:unit'].execute
      ensure
        ENV['COVERAGE'] = original
      end
    end
  rescue LoadError
    task :coverage do
      $stderr.puts "coverage is not available. In order to run simplecov, you must: gem install simplecov"
    end
  end
end
