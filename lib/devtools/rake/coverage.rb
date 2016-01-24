module Devtools
  module Rake
    # Coverage metric runner
    class Coverage < Base
      include Anima.new(:pattern)
      
      # Runs rspec with coverage
      #
      # @return [undefined]
      #
      # @api private
      def run
        auto_notify do
          begin
            original, ENV['COVERAGE'] = ENV['COVERAGE'], 'true'
           RSpec::Core::Runner.run(['spec'] + Dir[pattern])
          
          ensure
            ENV['COVERAGE'] = original
          end
        end
      end
      
    end
  end
end
