module Devtools
  module Rubocop
    # Proxy interface to rubocop
    class Proxy
      CONFIG_FLAG = '--config'.freeze

      include Procto.call(:to_result), Anima.new(:config_file, :directory)

      # Produce a result object for rubocop analysis
      #
      # @return [Result]
      #
      # @api private
      def to_result
        Result.new(status: RuboCop::CLI.new.run(cli_arguments))
      end

      private

      # Arguments for rubocop CLI
      #
      # @return [Array<String>]
      #
      # @api private
      def cli_arguments
        [CONFIG_FLAG, config_file, directory]
      end
    end

    # Rubocop result object
    class Result
      include Anima.new(:status)

      # Check if rubocop cli execution returned a success exit code
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
