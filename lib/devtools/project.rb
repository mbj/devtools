# encoding: utf-8

module Devtools

  # The project devtools supports
  class Project

    SHARED_SPEC_PATTERN   = '{shared,support}/**/*.rb'.freeze
    UNIT_TEST_TIMEOUT     = 0.1  # 100ms
    UNIT_TEST_PATH_REGEXP = %r{\bspec/unit/}.freeze

    # Return project root
    #
    # @return [Pathname]
    #
    # @api private
    #
    attr_reader :root

    # Setup rspec
    #
    # @param [Pathname] spec_root
    # @param [Numeric] timeout
    #
    # @return [Class<Devtools::Project>]
    #
    # @api private
    #
    def self.setup_rspec(spec_root, timeout)
      require 'rspec'
      require_shared_spec_files(Devtools.shared_path.join('spec'))
      require_shared_spec_files(spec_root)
      timeout_unit_tests(timeout) unless Devtools.jit?
      self
    end

    # Require shared examples
    #
    # @param [Pathname] spec_root
    #
    # @return [undefined]
    #
    # @api private
    #
    def self.require_shared_spec_files(spec_root)
      Dir[spec_root.join(SHARED_SPEC_PATTERN)].each { |file| require file }
    end
    private_class_method :require_shared_spec_files

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
    def self.timeout_unit_tests(timeout)
      RSpec.configuration.around file_path: UNIT_TEST_PATH_REGEXP do |example|
        Timeout.timeout(timeout, &example)
      end
    end
    private_class_method :timeout_unit_tests

    # Initialize object
    #
    # @param [Pathname] root
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(root)
      @root = root
    end

    # Return shared gemfile path
    #
    # @return [Pathname]
    #
    # @api private
    #
    def shared_gemfile_path
      @shared_gemfile_path ||= root.join('Gemfile.devtools').freeze
    end

    # Return default config path
    #
    # @return [Pathname]
    #
    # @api private
    #
    def default_config_path
      @default_config_path ||= root.join('config').freeze
    end

    # Return lib directory
    #
    # @return [Pathname]
    #
    # @api private
    #
    def lib_dir
      @lib_dir ||= root.join('lib').freeze
    end

    # Return file pattern
    #
    # @return [Pathname]
    #
    # @api private
    #
    def file_pattern
      @file_pattern ||= lib_dir.join('**/*.rb').freeze
    end

    # Return spec root
    #
    # @return [Pathname]
    #
    # @api private
    #
    def spec_root
      @spec_root ||= root.join('spec').freeze
    end

    # Setup rspec
    #
    # @return [self]
    #
    # @api private
    #
    def setup_rspec
      self.class.setup_rspec(spec_root, devtools.unit_test_timeout)
      self
    end

    # Return config directory
    #
    # @return [String]
    #
    # @api private
    #
    def config_dir
      @config_dir ||= root.join('config').freeze
    end

    # Return reek configuration
    #
    # @return [Config::Reek]
    #
    # @api private
    #
    def reek
      @reek ||= Config::Reek.new(self)
    end

    # Return rubocop configuration
    #
    # @return [Config::Rubocop]
    #
    # @api private
    #
    def rubocop
      @rubocop ||= Config::Rubocop.new(self)
    end

    # Return flog configuration
    #
    # @return [Config::Flog]
    #
    # @api private
    #
    def flog
      @flog ||= Config::Flog.new(self)
    end

    # Return yardstick configuration
    #
    # @return [Config::Yardstick]
    #
    # @api private
    #
    def yardstick
      @yardstick ||= Config::Yardstick.new(self)
    end

    # Return flay configuration
    #
    # @return [Config::Flay]
    #
    # @api private
    #
    def flay
      @flay ||= Config::Flay.new(self)
    end

    # Return mutant configuration
    #
    # @return [Config::Mutant]
    #
    # @api private
    #
    def mutant
      @mutant ||= Config::Mutant.new(self)
    end

    # Return devtools configuration
    #
    # @return [Config::Devtools]
    #
    # @api private
    def devtools
      @devtools ||= Config::Devtools.new(self)
    end

  end
end
