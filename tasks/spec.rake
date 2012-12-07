# encoding: utf-8

begin
  require 'rspec/core/rake_task'

  desc 'Run all specs'
  task :spec => %w[ spec:unit spec:integration ]

  namespace :spec do
    desc 'Run unit specs'
    RSpec::Core::RakeTask.new(:unit) do |unit|
      unit.pattern = 'spec/unit/**/*_spec.rb'
    end

    desc 'Run integration specs'
    RSpec::Core::RakeTask.new(:integration) do |integration|
      integration.pattern = 'spec/integration/**/*_spec.rb'
    end
  end
rescue LoadError
  %w[ spec spec:unit spec:integration ].each do |name|
    task name do
      $stderr.puts "rspec is not available. In order to run #{name}, you must: gem install rspec"
    end
  end
end

namespace :metrics do
  unless RUBY_VERSION < '1.9'
    desc 'Generate code coverage'
    RSpec::Core::RakeTask.new(:coverage) do |rcov|
      rcov.rcov      = true
      rcov.pattern   = 'spec/unit/**/*_spec.rb'
      rcov.rcov_opts = File.read('spec/rcov.opts').split(/\s+/)
    end
  end
end

task :test => :spec
