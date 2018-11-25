module Devtools
  module Rake
    # Flog metric runner
    class Flog
      include Procto.call(:verify),
              Adamantium,
              Concord.new(:config)

      # Verify flog integration runs successfully
      #
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Style/GuardClause
      # :reek:TooManyStatements
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        flog_threshold = config.threshold.round(1)
        flog      = ::Flog.new
        flog.flog(*FlogCLI.expand_dirs_to_files(config.lib_dirs))

        totals = flog.totals.select  { |name|     !name.slice(-5..-1).eql?('#none') }
                            .map     { |name, score| [name, score.round(1)] }
                            .sort_by { |_name, score|    score }

        if totals.any?
          max = totals.last.last
          unless max >= flog_threshold
            Devtools.notify_metric_violation "Adjust flog score down to #{max}"
          end
        end

        bad_methods = totals.select { |_name, score| score > flog_threshold }
        if bad_methods.any?
          bad_methods.reverse_each do |name, score|
            printf "%8.1f: %s\n", score, name
          end

          Devtools.notify_metric_violation(
            "#{bad_methods.size} methods have a flog complexity > #{flog_threshold}"
          )
        end
      end
    end
  end
end
