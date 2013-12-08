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
      $stderr.puts "In order to run #{name}, do: gem install rspec"
    end
  end
end

task :test => :spec
