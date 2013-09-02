# encoding: utf-8

module Devtools

  # The project devtools supports
  class Project

    # The reek configuration
    #
    # @return [Config::Reek]
    #
    # @api private
    attr_reader :reek

    # The rubocop configuration
    #
    # @return [Config::Rubocop]
    #
    # @api private
    attr_reader :rubocop

    # The flog configuration
    #
    # @return [Config::Flog]
    #
    # @api private
    attr_reader :flog

    # The yardstick configuration
    #
    # @return [Config::Yardstick]
    #
    # @api private
    attr_reader :yardstick

    # The flay configuration
    #
    # @return [Config::Flay]
    #
    # @api private
    attr_reader :flay

    # The mutant configuration
    #
    # @return [Config::Mutant]
    #
    # @api private
    attr_reader :mutant

    # The devtools configuration
    #
    # @return [Config::Devtools]
    #
    # @api private
    attr_reader :devtools

    # Return project root
    #
    # @return [Pathname]
    #
    # @api private
    #
    attr_reader :root

    # The shared gemfile path
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :shared_gemfile_path

    # The default config path
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :default_config_path

    # The lib directory
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :lib_dir

    # The rb file pattern
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :file_pattern

    # The spec root
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :spec_root

    # Return config directory
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :config_dir

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
      require_shared_spec_files(Devtools::SHARED_SPEC_PATH)
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

      @shared_gemfile_path = @root.join(GEMFILE_NAME).freeze
      @default_config_path = @root.join(DEFAULT_CONFIG_DIRECTORY_NAME).freeze
      @lib_dir             = @root.join(LIB_DIRECTORY_NAME).freeze
      @spec_root           = @root.join(SPEC_DIRECTORY_NAME).freeze
      @config_dir          = @root.join(DEFAULT_CONFIG_DIRECTORY_NAME).freeze
      @file_pattern        = @lib_dir.join(RB_FILE_PATTERN).freeze

      @reek      = Config::Reek.new(self)
      @rubocop   = Config::Rubocop.new(self)
      @flog      = Config::Flog.new(self)
      @yardstick = Config::Yardstick.new(self)
      @flay      = Config::Flay.new(self)
      @mutant    = Config::Mutant.new(self)
      @devtools  = Config::Devtools.new(self)
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

  end
end
