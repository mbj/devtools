# encoding: utf-8

desc 'Run all metrics and integration specs'
task ci: %w[ ci:metrics metrics:mutant spec:integration ]

namespace :ci do
  tasks = %w[
    metrics:coverage
    metrics:yardstick:verify
    metrics:rubocop
    metrics:flog
    metrics:flay
    metrics:reek
  ]

  desc 'Run metrics (except mutant)'
  task metrics: tasks
end
