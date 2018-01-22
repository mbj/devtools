# frozen_string_literal: true

module Devtools
  # Abstract base class of tool configuration
  class Config
    include Adamantium::Flat, AbstractType, Concord.new(:config_dir)

    # Represent no configuration
    DEFAULT_CONFIG = {}.freeze

    # Simple named type check representation
    class TypeCheck
      # Type check against expected class
      include Concord.new(:name, :allowed_classes)

      ERROR_FORMAT = '%<name>s: Got instance of %<got>s expected %<allowed>s'
      CLASS_DELIM  = ','

      # Check value for instance of expected class
      #
      # @param [Object] value
      #
      # @return [Object]
      def call(value)
        klass = value.class
        format_values = {
          name: name,
          got: klass,
          allowed: allowed_classes.join(CLASS_DELIM)
        }

        unless allowed_classes.any?(&klass.method(:equal?))
          fail TypeError, format(ERROR_FORMAT, format_values)
        end

        value
      end
    end # TypeCheck

    private_constant(*constants(false))

    # Error raised on type errors
    TypeError = Class.new(RuntimeError)

    # Declare an attribute
    #
    # @param [Symbol] name
    # @param [Array<Class>] classes
    #
    # @api private
    #
    # @return [self]
    #
    def self.attribute(name, classes, **options)
      default    = [options.fetch(:default)] if options.key?(:default)
      type_check = TypeCheck.new(name, classes)
      key        = name.to_s

      define_method(name) do
        type_check.call(raw.fetch(key, *default))
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
      config_dir.join(self.class::FILE)
    end
    memoize :config_file

  private

    # Return raw data
    #
    # @return [Hash]
    #
    # @api private
    #
    def raw
      yaml_config || DEFAULT_CONFIG
    end
    memoize :raw

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
      IceNine.deep_freeze(YAML.load_file(config_file)) if config_file.file?
    end

    # Rubocop configuration
    class Rubocop < self
      FILE = 'rubocop.yml'
    end # Rubocop

    # Reek configuration
    class Reek < self
      FILE = 'reek.yml'
    end # Reek

    # Flay configuration
    #
    class Flay < self
      FILE             = 'flay.yml'
      DEFAULT_LIB_DIRS = %w[lib].freeze
      DEFAULT_EXCLUDES = %w[].freeze

      attribute :total_score, [0.class]
      attribute :threshold,   [0.class]
      attribute :lib_dirs,    [Array], default: DEFAULT_LIB_DIRS
      attribute :excludes,    [Array], default: DEFAULT_EXCLUDES
    end # Flay

    # Yardstick configuration
    class Yardstick < self
      FILE    = 'yardstick.yml'
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
      FILE             = 'flog.yml'
      DEFAULT_LIB_DIRS = %w[lib].freeze

      attribute :total_score, [Float]
      attribute :threshold,   [Float]
      attribute :lib_dirs,    [Array], default: DEFAULT_LIB_DIRS
    end # Flog

    # Mutant configuration
    class Mutant < self
      FILE             = 'mutant.yml'
      DEFAULT_NAME     = ''
      DEFAULT_STRATEGY = 'rspec'

      attribute :name,            [String],                default: DEFAULT_NAME
      attribute :strategy,        [String],                default: DEFAULT_STRATEGY
      attribute :zombify,         [TrueClass, FalseClass], default: false
      attribute :since,           [String, NilClass],      default: nil
      attribute :ignore_subjects, [Array],                 default: []
      attribute :namespace,       [String]
    end # Mutant

    # Devtools configuration
    class Devtools < self
      FILE                      = 'devtools.yml'
      DEFAULT_UNIT_TEST_TIMEOUT = 0.1  # 100ms

      attribute :unit_test_timeout, [Float], default: DEFAULT_UNIT_TEST_TIMEOUT
    end # Devtools
  end # Config
end # Devtools
