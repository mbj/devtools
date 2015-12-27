module Devtools
  module Rake
    # Rubocop metric runner
    class Rubocop
      VIOLATION_MESSAGE = 'Rubocop not successful'.freeze

      include Anima.new(:config, :directory), Procto.call(:verify)

      # Verify rubocop integration runs successfully
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        fail VIOLATION_MESSAGE unless result.successful?
      rescue Encoding::CompatibilityError => exception
        Devtools.notify_metric_violation(exception.message)
      end

      private

      # Result object for rubocop analysis
      #
      # @return [Devtools::Rubocop::Result]
      #
      # @api private
      def result
        Devtools::Rubocop::Proxy.call(
          config_file: config.config_file.to_s,
          directory:   directory
        )
      end
    end
  end
end
