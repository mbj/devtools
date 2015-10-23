module Devtools

  # Abstract base class of tool configuration
  class Config
    include Concord.new(:project)

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

    # Return config path
    #
    # @return [String]
    #
    # @api private
    #
    def config_file
      @config_file ||= project.config_dir.join(self.class::FILE).freeze
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
    end # Rubocop

    # Reek configuration
    class Reek < self
      FILE = 'reek.yml'.freeze
    end # Reek

    # Flay configuration
    class Flay < self
      FILE             = 'flay.yml'.freeze
      DEFAULT_LIB_DIRS = %w[lib].freeze
      DEFAULT_EXCLUDES = %w[].freeze

      attribute :total_score
      attribute :threshold
      attribute :lib_dirs, DEFAULT_LIB_DIRS
      attribute :excludes, DEFAULT_EXCLUDES
    end # Flay

    # Yardstick configuration
    class Yardstick < self
      FILE    = 'yardstick.yml'.freeze
      OPTIONS = %w[
        threshold
        rules
        verbose
        path
        require_exact_threshold
      ].freeze

      # Options hash that Yardstick understands
      #
      # @return [Hash]
      #
      # @api private
      def options
        OPTIONS.each_with_object({}) do |name, hash|
          hash[name] = raw.fetch(name, nil)
        end
      end
    end # Yardstick

    # Flog configuration
    class Flog < self
      FILE             = 'flog.yml'.freeze
      DEFAULT_LIB_DIRS = %w[lib].freeze

      attribute :total_score
      attribute :threshold
      attribute :lib_dirs, DEFAULT_LIB_DIRS
    end # Flog

    # Mutant configuration
    class Mutant < self
      FILE             = 'mutant.yml'.freeze
      DEFAULT_NAME     = ''.freeze
      DEFAULT_STRATEGY = 'rspec'.freeze

      attribute :name,            DEFAULT_NAME
      attribute :strategy,        DEFAULT_STRATEGY
      attribute :zombify,         false
      attribute :since,           nil
      attribute :ignore_subjects, []
      attribute :expect_coverage, 1
      attribute :namespace
    end # Mutant

    # Devtools configuration
    class Devtools < self
      FILE                      = 'devtools.yml'.freeze
      DEFAULT_UNIT_TEST_TIMEOUT = 0.1  # 100ms

      attribute :unit_test_timeout, DEFAULT_UNIT_TEST_TIMEOUT
    end # Devtools
  end # config
end # Devtools
