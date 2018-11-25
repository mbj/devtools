module Devtools
  module Rake
    # Mutant metric runner
    class Mutant
      include Procto.call(:verify),
              Adamantium,
              Concord.new(:config)

      # Verify mutant integration runs successfully
      #
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Style/GuardClause
      # :reek:TooManyStatements
      # :reek:UncommunicativeVariableName
      # :reek:DuplicateMethodCall
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        namespaces = Array(config.namespace).map { |n| "#{n}*" }

        ignores = config.ignore_subjects.flat_map do |matcher|
          %W[--ignore #{matcher}]
        end

        mutant_since =
          if config.since
            %W[--since #{config.since}]
          else
            []
          end

        mutant_zombify =
          if config.zombify
            %w[--zombify]
          else
            []
          end

        arguments  = %W[
          --include lib
          --require #{config.name}
          --expect-coverage #{config.expect_coverage}
          --use #{config.strategy}
        ].concat(ignores).concat(namespaces).concat(mutant_since).concat(mutant_zombify)

        status = ::Mutant::CLI.run(arguments)
        if status.nonzero?
          Devtools.notify_metric_violation 'Mutant task is not successful'
        end
      end
    end
  end
end
