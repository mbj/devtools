require 'flay'

module Devtools
  module Tasks

    class Flay
      attr_reader :total_score
      private :total_score

      attr_reader :threshold
      private :threshold

      attr_reader :files
      private :files

      def self.call(config, project)
        new(config, ::Flay.expand_dirs_to_files(project.lib_dir).sort).call
      end

      def initialize(config, project)
        @total_score = config.total_score
        @threshold   = config.threshold
        @files = files
      end

      def call
        # Run flay first to ensure the max mass matches the threshold
        flay = run_flay

        max = (masses(flay).max || 0).to_i
        unless max >= threshold
          Devtools.notify "Adjust flay threshold down to #{max}"
        end

        total = masses(flay).reduce(:+).to_i
        unless total == total_score
          Devtools.notify "Flay total is now #{total}, but expected #{total_score}"
        end

        # Run flay a second time with the threshold set
        flay = run_flay(threshold.succ)

        mass_size = flay.masses.size

        if mass_size.nonzero?
          flay.report
          Devtools.notify "#{mass_size} chunks have a duplicate mass > #{threshold}"
        end
      end

      private
      def masses(flay)
        @masses ||= flay.masses.map do |hash, mass|
          Rational(mass, flay.hashes[hash].size)
        end
      end

      def run_flay(mass = 0)
        flay = ::Flay.new(fuzzy: false, verbose: false, mass: mass)
        flay.process(*files)
        flay.analyze
        return flay
      end

    end # class Flay
  end # module Task
end # module Devtools 

