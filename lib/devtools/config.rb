module Devtools
  # Abtract base class of tool configuration
  class Config

    # Default configuration for all tasks
    DEFAULT_CONFIG = {}.freeze

    # Declare raw accesors
    #
    # @api private
    #
    # @return [self]
    #
    def self.access(*names)
      names.each do |name|
        define_accessor(name)
      end
    end
    private_class_method :access

    # Define accessor
    #
    # @param [Symbol] name
    #
    # @return [self]
    #
    # @api private
    #
    def self.define_accessor(name)
      define_method(name) do
        raw.fetch(name.to_s)
      end
    end
    private_class_method :define_accessor

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
      raw.any?
    end

    private

    # Return raw data
    #
    # @return [Hash]
    #
    # @api private
    #
    def raw
      @raw ||= yaml_config || self.class::DEFAULT_CONFIG
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

    # Flay configuration
    class Flay < self
      FILE = 'flay.yml'.freeze

      access :total_score, :threshold
    end

    # Yardstick configuration
    class Yardstick < self
      FILE              = 'yardstick.yml'.freeze
      DEFAULT_THRESHOLD = 100
      DEFAULT_CONFIG    = {
        'threshold' => DEFAULT_THRESHOLD
      }.freeze

      access :threshold
    end

    # Flog configuration
    class Flog < self
      FILE = 'flog.yml'.freeze

      access :total_score, :threshold
    end

    # Mutant configuration
    class Mutant < self
      FILE = 'mutant.yml'.freeze

      access :name, :namespace, :strategy
    end

    # Devtools configuration
    class Devtools < self
      FILE           = 'devtools.yml'.freeze
      DEFAULT_CONFIG = {
        'unit_test_timeout' => ::Devtools::Project::UNIT_TEST_TIMEOUT
      }.freeze

      access :unit_test_timeout
    end
  end
end
