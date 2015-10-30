module Devtools
  module Rake
    # Rubocop metric runner
    class Rubocop < Base
      include Anima.new(:config_file)

      # Runs rubocop against the specified by `files`
      #
      # @return [undefined]
      #
      # @api private
      def run
        auto_notify do
          next notify_failure('Rubocop not successful') unless passed?
        end
      end

      def passed?
        RuboCop::CLI.new.run(%W[--config #{config_file}]).zero?
      end
    end
  end
end
