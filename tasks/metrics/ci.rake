# encoding: utf-8

desc 'Run metrics with Mutant'
task :ci => %w[ ci:metrics metrics:mutant ]

namespace :ci do
  desc 'Run metrics (except mutant) and spec'
  task :metrics => %w[ spec metrics:verify_measurements metrics:flog metrics:flay metrics:reek metrics:roodi ]
end
