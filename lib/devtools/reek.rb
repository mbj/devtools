module Devtools
  module Reek
    # Proxy interface to reek
    class Proxy
      CONFIG_FLAG = '--config'.freeze

      include Procto.call(:to_result), Anima.new(:config_file, :files)

      # Produce a result object for reek analysis
      #
      # @return [Result]
      #
      # @api private
      def to_result
        Result.new(status: reek.execute)
      end

      private

      # Configured reek CLI instance
      #
      # @return [::Reek::CLI::Application]
      #
      # @api private
      def reek
        ::Reek::CLI::Application.new(cli_arguments)
      end

      # Arguments for reek CLI
      #
      # @return [Array<String>]
      #
      # @api private
      def cli_arguments
        [CONFIG_FLAG, config_file, *files]
      end
    end

    # Reek result object
    class Result
      include Anima.new(:status)

      # Check if reek cli execution returned a success exit code
      #
      # @return [true] if status code is 0
      # @return [false] otherwise
      #
      # @api private
      def successful?
        status.zero?
      end
    end
  end
end
