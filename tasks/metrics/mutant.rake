namespace :metrics do
  config  = Devtools.project.mutant

  desc 'Measure mutation coverage'
  task mutant: :coverage do
    require 'mutant'

    namespace =
      if config.zombify
        Mutant.zombify
        Zombie::Mutant
      else
        Mutant
      end

    namespaces = Array(config.namespace).map { |n| "#{n}*" }

    ignore_subjects = config.ignore_subjects.flat_map do |matcher|
      %W[--ignore #{matcher}]
    end

    since =
      if config.since
        %W[--since #{config.since}]
      else
        []
      end

    arguments  = %W[
      --include lib
      --require #{config.name}
      --expect-coverage #{config.expect_coverage}
      --use #{config.strategy}
    ].concat(ignore_subjects).concat(namespaces).concat(since)

    status = namespace::CLI.run(arguments)
    if status.nonzero?
      Devtools.notify_metric_violation 'Mutant task is not successful'
    end
  end
end
