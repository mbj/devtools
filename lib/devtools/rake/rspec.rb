module Devtools
  module Rake
    # Coverage metric runner
    class Rspec < Base
      include Anima.new(:pattern)
      
      FAILURE = 'Specs did not pass'
      
      # Runs rspec with coverage
      #
      # @return [undefined]
      #
      # @api private
      def run
        auto_notify do
          next notify_failure(FAILURE) unless passed?
        end
      end
      
      private
      
      def passed?
        RSpec::Core::Runner.run(['spec'] + Dir[pattern]) == 0
      end
    end
  end
end
