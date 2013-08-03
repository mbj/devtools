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

  unless Devtools.project.yardstick.enabled?
    tasks.delete('metrics:yardstick:verify')
  end

  desc 'Run metrics (except mutant) and spec'
  task metrics: tasks
end
