# encoding: utf-8

namespace :metrics do
  begin
    require 'backports'
    require 'flog'

    project = Devtools.project

    # original code by Marty Andrews:
    # http://blog.martyandrews.net/2009/05/enforcing-ruby-code-quality.html
    desc 'Analyze for code complexity'
    task :flog do
      config    = project.flog
      threshold = config.threshold.to_f.round(1)
      flog = Flog.new
      flog.flog project.lib_dir

      totals = flog.totals.select  { |name, score| name[-5, 5] != '#none'   }.
                           map     { |name, score| [ name, score.round(1) ] }.
                           sort_by { |name, score| score }

      if totals.any?
        max = totals.last[1]
        unless max >= threshold
          raise "Adjust flog score down to #{max}"
        end
      end

      bad_methods = totals.select { |name, score| score > threshold }
      if bad_methods.any?
        bad_methods.reverse_each do |name, score|
          puts '%8.1f: %s' % [ score, name ]
        end

        raise "#{bad_methods.size} methods have a flog complexity > #{threshold}"
      end
    end
  rescue LoadError
    task :flog do
      $stderr.puts 'Flog is not available. In order to run flog, you must: gem install flog'
    end
  end
end
