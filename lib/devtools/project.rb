module Devtools
  # The project devtools supports
  class Project
    # Return project root
    #
    # @return [String] root
    #
    # @api private
    #
    attr_reader :root

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
    end

    # Return shared gemfile path
    #
    # @return [String]
    #
    # @api private
    #
    def shared_gemfile_path
      @shared_gemfile_path ||= root.join('Gemfile.devtools').freeze
    end

    # Return lib directory
    #
    # @return [String]
    #
    # @api private
    #
    def lib_dir
      @lib_dir ||= root.join('lib').freeze
    end

    # Return file pattern
    #
    # @return [String]
    #
    # @api private
    #
    def file_pattern
      @file_pattern ||= lib_dir.join('**/*.rb').freeze
    end

    # Return spec root
    #
    # @return [Pathname]
    #
    # @api private
    #
    def spec_root
      @spec_root ||= root.join('spec').freeze
    end

    # Setup rspec
    #
    # @return [self]
    #
    # @api private
    #
    def setup_rspec
      require 'rspec'
      Devtools.require_shared_examples
      require_shared_examples_and_support
      prepare_18_specific_quirks
    end

    # Return config directory
    #
    # @return [String]
    #
    # @api private
    #
    def config_dir
      @config_dir ||= root.join('config').freeze
    end

    # Return flog configuration
    #
    # @return [Config::Flog]
    #
    # @api private
    #
    def flog
      @flog ||= Config::Flog.new(self)
    end

    # Return roodi configuration
    #
    # @return [Config::Roodi]
    #
    # @api private
    #
    def roodi
      @roodi ||= Config::Roodi.new(self)
    end

    # Return yardstick configuration
    #
    # @return [Config::Yardstick]
    #
    # @api private
    #
    def yardstick
      @yardstick ||= Config::Yardstick.new(self)
    end

    # Return flay configuration
    #
    # @return [Config::Flay]
    #
    # @api private
    #
    def flay
      @flay ||= Config::Flay.new(self)
    end

    # Return mutant configuration
    #
    # @return [Config::Mutant]
    #
    # @api private
    #
    def mutant
      @mutant ||= Config::Mutant.new(self)
    end

  private

    # Require shared examples and spec support
    #
    # Requires all files in $root/spec/{shared,support}/**/*.rb
    #
    # @return [self]
    #
    # @api private
    #
    def require_shared_examples_and_support
      Dir[spec_root.join('{shared,support}/**/*.rb')].each { |file| require(file) }
      self
    end

    # Prepare spec quirks for 1.8
    #
    # @return [self]
    #
    # @api private
    #
    def prepare_18_specific_quirks
      if Devtools.ruby18?
        require 'rspec/autorun'
      end

      self
    end

  end
end
