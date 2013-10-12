# encoding: utf-8

namespace :metrics do
  begin
    require 'flog'
    require 'flog_cli'

    project = Develry.project
    config  = project.flog

    compatible_scores = %w(mri-1.9.3)

    if ! compatible_scores.include?(Develry.rvm)
      task :flog do
        $stderr.puts "Flog is disabled under #{Develry.rvm}"
      end
    elsif config.enabled?
      # Original code by Marty Andrews:
      # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
      desc 'Measure code complexity'
      task :flog do
        threshold = config.threshold.to_f.round(1)
        flog      = Flog.new
        flog.flog(*FlogCLI.expand_dirs_to_files(project.lib_dir))

        totals = flog.totals.select  { |name, score| name[-5, 5] != '#none' }
                            .map     { |name, score| [name, score.round(1)] }
                            .sort_by { |name, score| score }

        if totals.any?
          max = totals.last[1]
          unless max >= threshold
            Develry.notify "Adjust flog score down to #{max}"
          end
        end

        bad_methods = totals.select { |name, score| score > threshold }
        if bad_methods.any?
          bad_methods.reverse_each do |name, score|
            printf "%8.1f: %s\n", score, name
          end

          Develry.notify(
            "#{bad_methods.size} methods have a flog complexity > #{threshold}"
          )
        end
      end
    else
      task :flog do
        $stderr.puts 'Flog is disabled'
      end
    end
  rescue LoadError
    task :flog do
      $stderr.puts 'In order to run flog, you must: gem install flog'
    end
  end
end
