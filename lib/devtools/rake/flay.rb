module Devtools
  module Rake
    # :reek:IrresponsibleModule
    class Flay
      include Anima.new(:threshold, :total_score, :files), Procto.call(:verify)

      # rubocop:disable AbcSize, MethodLength, GuardClause
      # disable :reek:DuplicateMethodCall :reek:TooManyStatements
      def verify
        # Run flay first to ensure the max mass matches the threshold
        flay = ::Flay.new(mass: 0)
        flay.process(*files)
        flay.analyze

        masses = flay.masses.map do |hash, mass|
          Rational(mass, flay.hashes.fetch(hash).size)
        end

        max = masses.max.to_i
        unless max >= threshold
          Devtools.notify_metric_violation "Adjust flay threshold down to #{max}"
        end

        total = masses.inject(:+).to_i
        unless total.equal?(total_score)
          Devtools.notify_metric_violation "Flay total is now #{total}, but expected #{total_score}"
        end

        # Run flay a second time with the threshold set
        flay = ::Flay.new(mass: threshold.succ)
        flay.process(*files)
        flay.analyze

        mass_size = flay.masses.size

        if mass_size.nonzero?
          flay.report
          Devtools.notify_metric_violation "#{mass_size} chunks have a duplicate mass > #{threshold}"
        end
      end
    end
  end
end
