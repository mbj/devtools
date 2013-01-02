module Devtools
  # The project devtools supports
  class Project
    include Adamantium

    # Return project root
    #
    # @return [String] root
    #
    # @api private
    #
    attr_reader :root

    # Initialize object
    #
    # @param [String] root
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(root)
      @root = Pathname(root)
    end

    # Return shared gemfile path
    #
    # @return [String]
    #
    # @api private
    #
    def shared_gemfile_path
      root.join('Gemfile.devtools')
    end
    memoize :shared_gemfile_path

    # Return lib directory
    #
    # @return [String]
    #
    # @api private
    #
    def lib_dir
      root.join('lib')
    end
    memoize :lib_dir

    # Return file pattern
    #
    # @return [String]
    #
    # @api private
    #
    def file_pattern
      lib_dir.join('**/*.rb')
    end
    memoize :file_pattern

    # Return config directory
    #
    # @return [String]
    #
    # @api private
    #
    def config_dir
      root.join('config')
    end
    memoize :config_dir

    # Return flog configuration
    #
    # @return [Config::Flog]
    #
    # @api private
    #
    def flog
      Config::Flog.new(self)
    end
    memoize :flog

    # Return roodi configuration
    #
    # @return [Config::Roodi]
    #
    # @api private
    #
    def roodi
      Config::Roodi.new(self)
    end
    memoize :roodi

    # Return yardstick configuration
    #
    # @return [Config::Yardstick]
    #
    # @api private
    #
    def yardstick
      Config::Yardstick.new(self)
    end
    memoize :yardstick

    # Return flay configuration
    #
    # @return [Config::Flay]
    #
    # @api private
    #
    def flay
      Config::Flay.new(self)
    end
    memoize :flay

    # Return mutant configuration
    #
    # @return [Config::Mutant]
    #
    # @api private
    #
    def mutant
      Config::Mutant.new(self)
    end
    memoize :mutant

  end
end
