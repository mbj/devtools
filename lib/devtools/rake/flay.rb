module Devtools
  module Rake
    # :reek:IrresponsibleModule
    class Flay
      include Anima.new(:threshold, :total_score, :files), Procto.call(:verify), Adamantium

      BELOW_THRESHOLD = 'Adjust flay threshold down to %d'.freeze
      TOTAL_MISMATCH  = 'Flay total is now %d, but expected %d'.freeze
      ABOVE_THRESHOLD = '%d chunks have a duplicate mass > %d'.freeze

      # disable :reek:UtilityFunction
      def initialize(options)
        config = options.dup
        directories = config.delete(:directories)
        super(config.merge(files: ::Flay.expand_dirs_to_files(directories)))
      end

      # rubocop:disable MethodLength
      def verify
        # Run flay first to ensure the max mass matches the threshold
        Devtools.notify_metric_violation(
          BELOW_THRESHOLD % largest_mass
        ) if below_threshold?

        Devtools.notify_metric_violation(
          TOTAL_MISMATCH % [total_mass, total_score]
        ) if total_mismatch?

        # Run flay a second time with the threshold set
        return unless above_threshold?

        restricted_flay_scale.flay_report
        Devtools.notify_metric_violation(
          ABOVE_THRESHOLD % [restricted_mass_size, threshold]
        )
      end

    private

      def above_threshold?
        restricted_mass_size.nonzero?
      end

      def below_threshold?
        threshold > largest_mass
      end

      def total_mismatch?
        !total_mass.equal?(total_score)
      end

      def restricted_mass_size
        restricted_flay_scale.measure.size
      end

      def total_mass
        flay_masses.reduce(:+).to_i
      end

      def largest_mass
        flay_masses.max.to_i
      end

      def restricted_flay_scale
        Devtools::Flay::Scale.new(minimum_mass: threshold.succ, files: files)
      end
      memoize :restricted_flay_scale

      def flay_masses
        Devtools::Flay::Scale.call(minimum_mass: 0, files: files)
      end
      memoize :flay_masses
    end
  end
end
