module Devtools
  # Abtract base class of tool configuration
  class Config
    include Adamantium

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
      File.join(project.config_dir, self.class::FILE)
    end
    memoize :config_file


    # Return raw data
    #
    # @return [Hash]
    #
    # @api private
    #
    def raw
      return {} unless File.exists?(config_file)
      YAML.load_file(config_file)
    end
    memoize :raw

    # Declare raw accesors
    #
    # @api private
    #
    # @return [self]
    #
    def self.access(name, default_value)
      @access ||= {}
      @access[name] = default_value
      define_accessor(name, default_value)
    end
    private_class_method :access

    ##
    # All accessor needed by this config
    #
    # @return [ Hash ]
    #
    # @api private
    def self.accessor_needed
      @access || {}
    end

    # Define accessor
    #
    # @param [Symbol] name
    #
    # @return [self]
    #
    # @api private
    #
    def self.define_accessor(name, default_value)
      define_method(name) do
        raw.fetch(name.to_s, '')
      end
    end
    private_class_method :define_accessor

    ##
    # Create the config file need and define all default value if not present
    #
    # @return [ Boolean ]
    #
    # @api private
    #
    def prepare_file
      FileUtils.mkdir_p Devtools.project.config_dir
      FileUtils.touch(config_file) unless File.exists?(config_file)
      actual_value = YAML.load_file(config_file) || {}
      self.class.accessor_needed.each do |name, default_value|
        actual_value[name.to_s] ||= default_value
      end
      File.write(config_file, actual_value.to_yaml)
    end

    # Flay configuration
    class Flay < self
      FILE = 'flay.yml'.freeze
      access :total_score, 71
      access :threshold, 12
    end

    # Yardstick configuration
    class Yardstick < self
      FILE = 'yardstick.yml'.freeze
      access :threshold, 100
    end

    # Roodi configuration
    class Roodi < self
      FILE = 'roodi.yml'.freeze
    end

    # Flog configuration
    class Flog < self
      FILE = 'flog.yml'.freeze
      access :total_score, 100
      access :threshold, 18.3
    end

    # Mutant configuration
    class Mutant < self
      FILE = 'mutant.yml'.freeze
      access :name, ''
      access :namespace, ''
    end
  end
end
