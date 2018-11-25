module Devtools
  module Rake
    # Rubocop metric runner
    class Rubocop
      include Anima.new(:config, :directory), Procto.call(:verify)

      # Verify rubocop integration runs successfully
      #
      # rubocop:disable Style/RedundantBegin
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        begin
          exit_status = RuboCop::CLI.new.run(%W[--config #{config.config_file} #{directory}])
          fail 'Rubocop not successful' unless exit_status.zero?
        rescue Encoding::CompatibilityError => exception
          Devtools.notify_metric_violation exception.message
        end
      end
    end
  end
end
