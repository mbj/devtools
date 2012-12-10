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
end