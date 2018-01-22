# frozen_string_literal: true

module Devtools
  module Rake
    # Flay metric runner
    class Flay
      include Anima.new(:threshold, :total_score, :lib_dirs, :excludes),
              Procto.call(:verify),
              Adamantium

      BELOW_THRESHOLD = 'Adjust flay threshold down to %<mass>d'
      TOTAL_MISMATCH  = 'Flay total is now %<mass>d, but expected %<expected>d'
      ABOVE_THRESHOLD = '%<mass>d chunks have a duplicate mass > %<threshold>d'

      # Verify code specified by `files` does not violate flay expectations
      #
      # @raise [SystemExit] if a violation is found
      # @return [undefined] otherwise
      #
      #
      # @api private
      def verify
        # Run flay first to ensure the max mass matches the threshold
        below_threshold_message if below_threshold?

        total_mismatch_message if total_mismatch?

        # Run flay a second time with the threshold set
        return unless above_threshold?

        restricted_flay_scale.flay_report
        above_threshold_message
      end

    private

      # List of files flay will analyze
      #
      # @return [Set<Pathname>]
      #
      # @api private
      def files
        Devtools::Flay::FileList.call(lib_dirs, excludes)
      end

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

      # Above threshold message
      #
      # @return [String]
      #
      # @api private
      def above_threshold_message
        format_values = { mass: restricted_mass_size, threshold: threshold }
        Devtools.notify_metric_violation(
          format(ABOVE_THRESHOLD, format_values)
        )
      end

      # Below threshold message
      #
      # @return [String]
      #
      # @api private
      def below_threshold_message
        Devtools.notify_metric_violation(
          format(BELOW_THRESHOLD, mass: largest_mass)
        )
      end

      # Total mismatch message
      #
      # @return [String]
      #
      # @api private
      def total_mismatch_message
        Devtools.notify_metric_violation(
          format(TOTAL_MISMATCH, mass: total_mass, expected: total_score)
        )
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
