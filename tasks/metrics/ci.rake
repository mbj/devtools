# encoding: utf-8

desc 'Run metrics with Mutant'
task ci: %w[ ci:metrics metrics:mutant ]

namespace :ci do
  tasks = %w[
    metrics:coverage
    spec:integration
    metrics:yardstick:verify
    metrics:rubocop
    metrics:flog
    metrics:flay
    metrics:reek
  ]

  desc 'Run metrics (except mutant) and spec'
  task metrics: tasks
end
