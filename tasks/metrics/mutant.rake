# rubocop:disable Metrics/BlockLength
namespace :metrics do
  config = Devtools.project.mutant

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

    jobs = ENV.key?('CIRCLECI') ? %w[--jobs 4] : []

    since =
      if config.since
        %W[--since #{config.since}]
      else
        []
      end

    arguments = %W[
      --include lib
      --require #{config.name}
      --use #{config.strategy}
    ].concat(ignore_subjects).concat(namespaces).concat(since).concat(jobs)

    unless namespace::CLI.run(arguments)
      Devtools.notify_metric_violation('Mutant task is not successful')
    end
  end
end
# rubocop:enable Metrics/BlockLength
