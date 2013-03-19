module Devtools
  # Abtract base class of tool configuration
  class Config

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

    # Return raw data
    #
    # @return [Hash]
    #
    # @api private
    #
    def raw
      @raw ||= YAML.load_file(config_file).freeze
    end

    # Flay configuration
    class Flay < self
      FILE = 'flay.yml'.freeze
      access :total_score, :threshold
    end

    # Yardstick configuration
    class Yardstick < self
      FILE = 'yardstick.yml'.freeze
      access :threshold

      DEFAULT_THRESHOLD = 100

      DEFAULT_CONFIG = {
        'threshold' => DEFAULT_THRESHOLD
      }.freeze

      def raw
        @raw ||= File.exist?(config_file) ? yaml_config : DEFAULT_CONFIG
      end

      private

      def yaml_config
        YAML.load_file(config_file).freeze
      end
    end

    # Roodi configuration
    class Roodi < self
      FILE = 'roodi.yml'.freeze
    end

    # Flog configuration
    class Flog < self
      FILE = 'flog.yml'.freeze
      access :total_score, :threshold
    end

    # Mutant configuration
    class Mutant < self
      FILE = 'mutant.yml'.freeze
      access :name, :namespace
    end
  end
end
