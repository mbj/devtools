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
      @root = root
    end

    # Return shared gemfile path
    # 
    # @return [String]
    #
    # @api private
    #
    def shared_gemfile_path
      File.join(root, 'Gemfile.devtools')
    end
    memoize :shared_gemfile_path

    # Return lib directory
    #
    # @param [String] 
    #
    # @api private
    #
    def lib_dir
      File.join(root, 'lib')
    end
    memoize :lib_dir

    # Return file pattern
    #
    # @return [String]
    #
    # @api private
    #
    def file_pattern
      File.join(lib_dir, '**/*.rb')
    end
    memoize :file_pattern

    # Return config directory
    #
    # @return [String]
    #
    # @api private
    #
    def config_dir
      File.join(root, 'config')
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

    # Return heckle configuration
    #
    # @return [Config::Heckle]
    #
    # @api private
    #
    def heckle
      Config::Heckle.new(self)
    end
    memoize :heckle
  end
end
