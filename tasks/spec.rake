begin
  # Remove existing same-named tasks
  %w[spec spec:unit spec:integration].each do |task|
    klass = Rake::Task
    klass[task].clear if klass.task_defined?(task)
  end

  desc 'Run all specs'
  task :spec do
    Devtools::Rake::Rspec.call(
      pattern: 'spec/{unit,integration}/**/*_spec.rb'
    )
  end

  namespace :spec do
    desc 'Run unit specs'
    task :unit do
      Devtools::Rake::Rspec.call(
        pattern: 'spec/unit/**/*_spec.rb'
      )
    end

    desc 'Run integration specs'
     task :unit do
      Devtools::Rake::Rspec.call(
        pattern: 'spec/integration/**/*_spec.rb'
      )
    end
  end
  
rescue LoadError
  %w[spec spec:unit spec:integration].each do |name|
    task name do
      $stderr.puts "In order to run #{name}, do: gem install rspec"
    end
  end
end

task test: :spec
