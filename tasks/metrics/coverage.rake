namespace :metrics do
  desc 'Measure code coverage'
  task :coverage do
    Devtools::Rake::Coverage.call(
      pattern: 'spec/unit/**/*_spec.rb'
    )
  end
end
