module Devtools
  module Rake
    # Flog metric runner
    class Flog
      BELOW_THRESHOLD     = 'Adjust flog score down to %0.1f'.freeze
      ABOVE_THRESHOLD     = '%d methods have a flog complexity > %0.1f'.freeze
      THRESHOLD_PRECISION = 1

      include Procto.call(:verify),
              Adamantium,
              Concord.new(:config)

      # Verify flog integration runs successfully
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        return if verified?

        if result.below_threshold?
          Devtools.notify_metric_violation(BELOW_THRESHOLD % totals.max_score)
        end

        puts above_threshold

        Devtools.notify_metric_violation(
          ABOVE_THRESHOLD % [above_threshold.size, threshold]
        )
      end

      private

      # Check if flog results are satisfactory
      #
      # @return [true] if flog did not return any data
      # @return [true] if largest threshold equals configured threshold
      # @return [false] otherwise
      #
      # @api private
      def verified?
        totals.empty? || result.at_threshold?
      end

      # Collection of totals above threshold
      #
      # @return [Total::Collection]
      #
      # @api private
      def above_threshold
        result.above
      end

      # Result object for flog data and expected threshold
      #
      # @return [Devtools::Flog::Result]
      #
      # @api private
      def result
        Devtools::Flog::Result.new(
          totals:    totals,
          threshold: threshold
        )
      end
      memoize :result

      # Collection of flog totals produced from analyzing `file_list`
      #
      # @return [Total::Collection]
      #
      # @api private
      def totals
        Devtools::Flog::Proxy.new(file_list).totals
      end
      memoize :totals

      # List of files for flog to analyze corresponding to `config.lib_dirs`
      #
      # @return [Array<String>]
      #
      # @api private
      def file_list
        Devtools::Flog::FileList.call(config.lib_dirs)
      end

      # Rounded threshold for evaluating flog result totals
      #
      # @return [Float]
      #
      # @api private
      def threshold
        config.threshold.round(THRESHOLD_PRECISION)
      end
    end
  end
end
