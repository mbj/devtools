# encoding: utf-8

namespace :metrics do
  begin
    require 'flay'

    project = Devtools.project
    config  = project.flay

    compatible_scores = %w(mri-1.9.3 mri-2.0.0 mri-2.1.0 mri-2.1.1)

    if ! compatible_scores.include?(Devtools.rvm)
      task :flay do
        $stderr.puts "Flay is disabled under #{Devtools.rvm}"
      end
    elsif config.enabled?
      # Original code by Marty Andrews:
      # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
      desc 'Measure code duplication'
      task :flay do
        threshold   = config.threshold
        total_score = config.total_score
        files       = Flay.expand_dirs_to_files(project.lib_dir).sort

        # Run flay first to ensure the max mass matches the threshold
        flay = Flay.new(fuzzy: false, verbose: false, mass: 0)
        flay.process(*files)
        flay.analyze

        masses = flay.masses.map do |hash, mass|
          Rational(mass, flay.hashes[hash].size)
        end

        max = (masses.max || 0).to_i
        unless max >= threshold
          Devtools.notify_metric_violation "Adjust flay threshold down to #{max}"
        end

        total = masses.inject(:+).to_i
        unless total == total_score
          Devtools.notify_metric_violation "Flay total is now #{total}, but expected #{total_score}"
        end

        # Run flay a second time with the threshold set
        flay = Flay.new(fuzzy: false, verbose: false, mass: threshold.succ)
        flay.process(*files)
        flay.analyze

        mass_size = flay.masses.size

        if mass_size.nonzero?
          flay.report
          Devtools.notify_metric_violation "#{mass_size} chunks have a duplicate mass > #{threshold}"
        end
      end
    else
      task :flay do
        $stderr.puts 'Flay is disabled'
      end
    end
  rescue LoadError
    task :flay do
      $stderr.puts 'In order to run flay, you must: gem install flay'
    end
  end
end
