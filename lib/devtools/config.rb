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
      YAML.load_file(config_file)
    end
    memoize :raw

    module Threshold
      # Return threshold
      #
      # @return [Float]
      #
      # @api private
      #
      def threshold
        raw.fetch('threshold')
      end
    end

    module TotalScore
      # Return total score
      #
      # @return [Float]
      #
      # @api private
      #
      def total_score
        raw.fetch('total_score')
      end
    end

    # Flay configuration
    class Flay < self
      include Threshold
      include TotalScore
      FILE = 'flay.yml'.freeze
    end

    # Yardstick configuration
    class Yardstick < self
      include Threshold
      FILE = 'yardstick.yml'.freeze
    end

    # Roodi configuration
    class Roodi < self
      FILE = 'roodi.yml'.freeze
    end

    # Flog configuration
    class Flog < self
      include Threshold
      include TotalScore
      FILE = 'flog.yml'.freeze
    end

    # Deserialize config file
    #
    # @param [String] path
    #
    # @return [Hash, Array]
    #
    def self.deserialize(file)
      YAML.load_file(file)
    end
  end
end
