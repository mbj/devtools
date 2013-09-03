module Devtools
  class Project
    class Initializer

      class Rspec < self

        # Initialize rspec for +project+
        #
        # @param [Project] project
        #   the project to initialize
        #
        # @return [Rspec]
        #
        # @api private
        def self.call(project)
          new(project).call
        end

        # Require shared examples
        #
        # @param [Pathname] dir
        #   the directory containing the files to require
        #
        # @param [String] pattern
        #   the file pattern to match inside directory
        #
        # @return [self]
        #
        # @api private
        def self.require_files(dir, pattern)
          Dir[dir.join(pattern)].each { |file| require file }
          self
        end

        # The spec root
        #
        # @return [Pathname]
        #
        # @api private
        attr_reader :spec_root
        private     :spec_root

        # The unit test timeout
        #
        # @return [Numeric]
        #
        # @api private
        attr_reader :unit_test_timeout
        private     :unit_test_timeout

        # Initialize a new instance
        #
        # @param [Project] project
        #   the project to initialize
        #
        # @param [Numeric] unit_test_timeout
        #   the maximum time a single unit test can take
        #
        # @return [undefined]
        #
        # @api private
        def initialize(project)
          super
          @spec_root         = project.spec_root
          @unit_test_timeout = project.unit_test_timeout
        end

        # Setup rspec for {#project}
        #
        # @return [self]
        #
        # @api private
        def call
          require 'rspec'
          require_shared_spec_files
          enable_unit_test_timeout unless Devtools.jit?
          self
        end

        private

        # Timeout unit tests that take longer than 1/10th of a second
        #
        # @param [Numeric] timeout
        #
        # @return [undefined]
        #
        # @raise [Timeout::Error]
        #   raised when the times are outside the timeout
        #
        # @api private
        #
        def enable_unit_test_timeout
          timeout = unit_test_timeout # support the closure
          RSpec.configuration.around file_path: UNIT_TEST_PATH_REGEXP do |example|
            Timeout.timeout(timeout, &example)
          end
        end

        def require_shared_spec_files
          require_files(SHARED_SPEC_PATH)
          require_files(spec_root)
        end

        def require_files(directory)
          self.class.require_files(directory, SHARED_SPEC_PATTERN)
        end

      end # class Rspec
    end # class Initializer
  end # class Project
end # module Devtools
