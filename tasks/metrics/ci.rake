desc 'Run all specs and metrics'
task ci: %w[ci:metrics]

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
end
