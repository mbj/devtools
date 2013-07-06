module Devtools

  # Abstract base class of tool configuration
  class Config

    # Represent no configuration
    DEFAULT_CONFIG = {}.freeze

    # Declare an attribute
    #
    # @param [Symbol] name
    #
    # @yieldreturn [Object]
    #   the default value to use
    #
    # @api private
    #
    # @return [self]
    #
    def self.attribute(name, *default)
      define_method(name) do
        raw.fetch(name.to_s, *default)
      end
    end
    private_class_method :attribute

    # Return project
    #
    # @return [Project]
    #
    # @api private
    #
    attr_reader :project

    # Initialize object
    #
    # @return [Project]
    #
    # @api private
    #
    def initialize(project)
      @project = project
    end

    # Return config path
    #
    # @return [String]
    #
    # @api private
    #
    def config_file
      @config_file ||= project.config_dir.join(self.class::FILE).freeze
    end

    # Test if the task is enabled
    #
    # If there is no config file, and no sensible defaults, then the rake task
    # should become disabled.
    #
    # @return [Boolean]
    #
    # @api private
    #
    def enabled?
      ! raw.equal?(DEFAULT_CONFIG)
    end

    private

    # Return raw data
    #
    # @return [Hash]
    #
    # @api private
    #
    def raw
      @raw ||= yaml_config || DEFAULT_CONFIG
    end

    # Return the raw config data from a yaml file
    #
    # @return [Hash]
    #   returned if the yaml file is found
    # @return [nil]
    #   returned if the yaml file is not found
    #
    # @api private
    #
    def yaml_config
      config_file = self.config_file
      YAML.load_file(config_file).freeze if config_file.file?
    end

    # Rubocop configuration
    class Rubocop < self
      FILE = 'rubocop.yml'.freeze
    end

    # Flay configuration
    class Flay < self
      FILE = 'flay.yml'.freeze

      attribute :total_score
      attribute :threshold
    end

    # Yardstick configuration
    class Yardstick < self
      FILE              = 'yardstick.yml'.freeze
      DEFAULT_THRESHOLD = 100

      attribute :threshold, DEFAULT_THRESHOLD
    end

    # Flog configuration
    class Flog < self
      FILE = 'flog.yml'.freeze

      attribute :total_score
      attribute :threshold
    end

    # Mutant configuration
    class Mutant < self
      FILE             = 'mutant.yml'.freeze
      DEFAULT_STRATEGY = '--rspec-dm2'.freeze

      attribute :name
      attribute :namespace
      attribute :strategy, DEFAULT_STRATEGY
    end

    # Devtools configuration
    class Devtools < self
      FILE = 'devtools.yml'.freeze

      attribute :unit_test_timeout, ::Devtools::Project::UNIT_TEST_TIMEOUT
    end
  end
end
