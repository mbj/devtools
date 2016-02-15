module Devtools

  # The project devtools supports
  class Project
    include Concord.new(:root)

    CONFIGS = {
      devtools:  Config::Devtools,
      flay:      Config::Flay,
      flog:      Config::Flog,
      reek:      Config::Reek,
      mutant:    Config::Mutant,
      rubocop:   Config::Rubocop,
      yardstick: Config::Yardstick
    }.freeze

    private_constant(*constants(false))

    attr_reader(*CONFIGS.keys)

    # The spec root
    #
    # @return [Pathname]
    #
    # @api private
    attr_reader :spec_root

    # Initialize object
    #
    # @param [Pathname] root
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(root)
      super(root)

      initialize_environment
      initialize_configs
    end

    # Init rspec
    #
    # @return [self]
    #
    # @api private
    def init_rspec
      Initializer::Rspec.call(self)
      self
    end

  private

    # Initialize environment
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize_environment
      @spec_root = root.join(SPEC_DIRECTORY_NAME)
    end

    # Initialize configs
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize_configs
      config_dir = root.join(DEFAULT_CONFIG_DIR_NAME)

      CONFIGS.each do |name, klass|
        instance_variable_set(:"@#{name}", klass.new(config_dir))
      end
    end

  end # class Project
end # module Devtools
