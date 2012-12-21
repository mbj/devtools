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
        raw.fetch(name.to_s, '')
      end
    end
    private_class_method :define_accessor

    # Flay configuration
    class Flay < self
      FILE = 'flay.yml'.freeze
      access :total_score, :threshold
    end

    # Yardstick configuration
    class Yardstick < self
      FILE = 'yardstick.yml'.freeze
      access :threshold
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
