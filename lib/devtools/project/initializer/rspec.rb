# encoding: utf-8

module Devtools
  class Project
    class Initializer

      # Requires all shared specs in a project's spec_helper
      # Also installs a configurable unit test timeout
      class Rspec < self

        def self.require_files(directory)
          Devtools.require_files(directory, SHARED_SPEC_PATTERN)
        end

        # Initialize RSpec for +project+
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

        # The spec root
        #
        # @return [Pathname]
        #
        # @api private
        attr_reader :spec_root
        private :spec_root

        # The unit test timeout
        #
        # @return [Numeric]
        #
        # @api private
        attr_reader :unit_test_timeout
        private :unit_test_timeout

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

        # Setup RSpec for {#project}
        #
        # @return [self]
        #
        # @api private
        def call
          require 'rspec'
          require 'rspec/its'
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
          self.class.require_files(directory)
        end

      end # class Rspec
    end # class Initializer
  end # class Project
end # module Devtools
