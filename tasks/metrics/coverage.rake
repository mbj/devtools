begin
  require 'rspec/core/rake_task'

  namespace :metrics do
    unless RUBY_VERSION < '1.9'
      desc 'Generate code coverage'
      RSpec::Core::RakeTask.new(:coverage) do |spec|
        ENV['COVERAGE'] = 'true'
        spec.pattern = 'spec/unit/**/*_spec.rb'
      end
    end
  end
rescue LoadError
  namespace :metrics do
    task :coverage do
      $stderr.puts 'Coverage is not available. In order to run coverage, you must: gem install rspec'
    end
  end
end
