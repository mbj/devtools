# rubocop:disable Metrics/BlockLength
namespace :metrics do
  require 'flog'
  require 'flog_cli'

  project = Devtools.project
  config  = project.flog

  # Original code by Marty Andrews:
  # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
  desc 'Measure code complexity'
  task :flog do
    threshold = config.threshold.to_f.round(1)
    flog      = Flog.new
    flog.flog(*PathExpander.new(config.lib_dirs.dup, '**/*.rb').process)

    totals = flog
      .totals
      .reject  { |name, _score| name.end_with?('#none') }
      .map     { |name, score| [name, score.round(1)]   }
      .sort_by { |_name, score| score                   }

    if totals.any?
      max = totals.last[1]
      unless max >= threshold
        Devtools.notify_metric_violation "Adjust flog score down to #{max}"
      end
    end

    bad_methods = totals.select { |_name, score| score > threshold }

    if bad_methods.any?
      bad_methods.reverse_each do |name, score|
        printf "%8.1f: %s\n", score, name
      end

      Devtools.notify_metric_violation(
        "#{bad_methods.size} methods have a flog complexity > #{threshold}"
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
