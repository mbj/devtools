module Devtools
  class Project
    class Initializer

      # Requires all shared specs in a project's spec_helper
      # Also installs a configurable unit test timeout
      class Rspec < self
        include Concord.new(:project)

        INTEGRATION_TEST_FILTER = IceNine.deep_freeze(
          file_path: INTEGRATION_TEST_PATH_REGEXP
        )

        UNIT_TEST_FILTER = IceNine.deep_freeze(
          file_path: UNIT_TEST_PATH_REGEXP
        )

        private_constant(*constants(false))

        # Call initializer for project
        #
        # @param [Project] project
        #
        # @return [self]
        #
        # @api private
        def self.call(project)
          new(project).__send__(:call)
          self
        end

      private

        # Setup RSpec for project
        #
        # @return [self]
        #
        # @api private
        def call
          require_shared_spec_files
          enable_unit_test_timeout
          disable_mutant_for_integration_tests
        end

        # Assign RSpec metadata to integration tests to disable mutant
        #
        # :reek:UtilityFunction for the sake of setting up RSpec project state
        #
        # @return [undefined]
        #
        # @api private
        #
        def disable_mutant_for_integration_tests
          RSpec
            .configuration
            .define_derived_metadata(INTEGRATION_TEST_FILTER) do |metadata|
              metadata[:mutant] = false
            end
        end

        # Timeout unit tests that take longer than configured amount of time
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
          timeout = project.devtools.unit_test_timeout
          RSpec.configuration.around(UNIT_TEST_FILTER) do |example|
            Timeout.timeout(timeout, &example)
          end
        end

        # Trigger the require of shared spec files
        #
        # @return [undefined]
        #
        # @api private
        #
        def require_shared_spec_files
          require_files(SHARED_SPEC_PATH)
          require_files(project.spec_root)
        end

        # Require files with pattern
        #
        # @param [Pathname] dir
        #   the directory containing the files to require
        #
        # @return [self]
        #
        # @api private
        def require_files(dir)
          Dir.glob(dir.join(SHARED_SPEC_PATTERN)).each(&Kernel.method(:require))
        end

      end # class Rspec
    end # class Initializer
  end # class Project
end # module Devtools
