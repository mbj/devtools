module Devtools
  module Rake
    # Reek metric runner
    class Reek
      include Procto.call(:verify), Adamantium, Concord.new(:config)

      # Verify reek integration runs successfully
      #
      # @raise [SystemExit] if unsuccessful
      # @return [undefined] otherwise
      #
      # @api private
      def verify
        arguments = %W[--config #{config.config_file}] + files

        status = ::Reek::CLI::Application.new(arguments).execute

        return if status.zero?

        Devtools.notify_metric_violation("\n\n!!! Reek has found smells - exiting!")
      end

      private

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
