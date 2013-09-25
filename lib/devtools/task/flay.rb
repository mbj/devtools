require 'flay'

module Devtools
  module Task

    class Flay

      def self.call(config, project)
        threshold   = config.threshold
        total_score = config.total_score
        files       = ::Flay.expand_dirs_to_files(project.lib_dir).sort

        # Run flay first to ensure the max mass matches the threshold
        flay = ::Flay.new(fuzzy: false, verbose: false, mass: 0)
        flay.process(*files)
        flay.analyze

        masses = flay.masses.map do |hash, mass|
          Rational(mass, flay.hashes[hash].size)
        end

        max = (masses.max || 0).to_i
        unless max >= threshold
          Devtools.notify "Adjust flay threshold down to #{max}"
        end

        total = masses.reduce(:+).to_i
        unless total == total_score
          Devtools.notify "Flay total is now #{total}, but expected #{total_score}"
        end

        # Run flay a second time with the threshold set
        flay = ::Flay.new(fuzzy: false, verbose: false, mass: threshold.succ)
        flay.process(*files)
        flay.analyze

        mass_size = flay.masses.size

        if mass_size.nonzero?
          flay.report
          Devtools.notify "#{mass_size} chunks have a duplicate mass > #{threshold}"
        end
      end

    end # class Flay
  end # module Task
end # module Devtools 

