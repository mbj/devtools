module Devtools
  module Rake
    # Reek metric runner
    class Reek
      VIOLATION_MESSAGE = "\n\n!!! Reek has found smells - exiting!".freeze

      include Procto.call(:verify), Adamantium, Concord.new(:config)

      # Verify reek integration runs successfully
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        return if result.successful?

        Devtools.notify_metric_violation(VIOLATION_MESSAGE)
      end

      private

      # Result object from running reek analysis
      #
      # @return [Devtools::Reek::Result]
      #
      # @api private
      def result
        Devtools::Reek::Proxy.call(
          config_file: config.config_file.to_s,
          files:       files
        )
      end

      # List of files to pass into reek task
      #
      # @return [Array<String>]
      #
      # @api private
      def files
        Dir.glob(config.files)
      end
    end
  end
end
