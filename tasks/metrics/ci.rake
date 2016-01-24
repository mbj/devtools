desc 'Run all specs, metrics and mutant'
task ci: %w[ci:metrics metrics:mutant]

namespace :ci do
  tasks = %w[
    metrics:coverage
    metrics:yardstick:verify
    metrics:rubocop
    metrics:flog
    metrics:flay
    metrics:reek
    spec:integration
  ]

  desc 'Run metrics (except mutant)'
  task metrics: tasks
end
