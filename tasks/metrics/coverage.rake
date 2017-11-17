namespace :metrics do
  desc 'Measure code coverage'
  task :coverage do
    begin
      # rubocop:disable Style/ParallelAssignment
      original, ENV['COVERAGE'] = ENV['COVERAGE'], 'true'
      Rake::Task['spec:unit'].execute
    ensure
      ENV['COVERAGE'] = original
    end
  end
end
