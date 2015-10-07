module Devtools
  module Rake
    # Flay metric runner
    class Flay
      include Anima.new(:threshold, :total_score, :files), Procto.call(:verify), Adamantium

      BELOW_THRESHOLD = 'Adjust flay threshold down to %d'.freeze
      TOTAL_MISMATCH  = 'Flay total is now %d, but expected %d'.freeze
      ABOVE_THRESHOLD = '%d chunks have a duplicate mass > %d'.freeze

      # Initialize flay task settings
      #
      # disable :reek:UtilityFunction
      #
      # @param options [Hash] flay options
      # @option threshold [Integer] :threshold maximum flay threshold
      # @option total_score [Integer] :total_score maximum allowed mass
      # @option directories [Array<String>] :directories directories for flay
      #
      # @return [undefined]
      #
      # @api private
      def initialize(options)
        config = options.dup
        directories = config.delete(:directories)
        super(config.merge(files: ::Flay.expand_dirs_to_files(directories)))
      end

      # Verify code specified by `files` does not violate flay expectations
      #
      # @raise [SystemExit] if a violation is found
      # @return [undefined] otherwise
      #
      # rubocop:disable MethodLength
      #
      # @api private
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

      # Is there mass duplication which exceeds specified `threshold`
      #
      # @return [Boolean]
      #
      # @api private
      def above_threshold?
        restricted_mass_size.nonzero?
      end

      # Is the specified `threshold` greater than the largest flay mass
      #
      # @return [Boolean]
      #
      # @api private
      def below_threshold?
        threshold > largest_mass
      end

      # Is the expected mass total different from the actual mass total
      #
      # @return [Boolean]
      #
      # @api private
      def total_mismatch?
        !total_mass.equal?(total_score)
      end

      # Size of mass measured by `Flay::Scale` and filtered by `threshold`
      #
      # @return [Integer]
      #
      # @api private
      def restricted_mass_size
        restricted_flay_scale.measure.size
      end

      # Sum of all flay mass
      #
      # @return [Integer]
      #
      # @api private
      def total_mass
        flay_masses.reduce(:+).to_i
      end

      # Largest flay mass found
      #
      # @return [Integer]
      #
      # @api private
      def largest_mass
        flay_masses.max.to_i
      end

      # Flay scale which only measures mass above `threshold`
      #
      # @return [Flay::Scale]
      #
      # @api private
      def restricted_flay_scale
        Devtools::Flay::Scale.new(minimum_mass: threshold.succ, files: files)
      end
      memoize :restricted_flay_scale

      # All flay masses found in `files`
      #
      # @return [Array<Rational>]
      #
      # @api private
      def flay_masses
        Devtools::Flay::Scale.call(minimum_mass: 0, files: files)
      end
      memoize :flay_masses
    end
  end
end
