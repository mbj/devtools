module Devtools
  module Rake
    # Flog metric runner
    class Flog < Base
      include Anima.new(:threshold, :lib_dirs)

      BELOW_THRESHOLD = 'Adjust flog score down to %d'.freeze
      ABOVE_THRESHOLD = '%d methods have a flog complexity > %d'.freeze

      # Runs flog against the specified by `files`
      #
      # @return [undefined]
      #
      # rubocop:disable Metrics/MethodLength
      #
      # @api private
      def run
        auto_notify do
          if above_threshold?
            bad_methods.each do |name, score|
              printf "%8.1f: %s\n", score, name
            end

            next notify_failure(
              format(ABOVE_THRESHOLD, bad_methods.size, threshold)
            )
          end

          next notify_failure(
            format(BELOW_THRESHOLD, max)
          ) if below_threshold?
        end
      end

      private

      def files
        FlogCLI.expand_dirs_to_files(lib_dirs)
      end

      def above_threshold?
        bad_methods.any?
      end

      def below_threshold?
        totals.any? && threshold > max
      end

      def max
        totals.first[1]
      end

      def flog
        instance = ::Flog.new
        instance.flog(*files)
        instance
      end
      memoize :flog

      def totals
        flog.totals.select { |name, _score| name[-5, 5] != '#none' }
          .map { |name, score| [name, score.round(1)] }
          .sort_by { |_name, score| score }.reverse
      end

      def bad_methods
        totals.select { |_name, score| score > threshold }
      end
    end
  end
end
