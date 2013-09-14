# encoding: utf-8

module Devtools

  # Provides methods to determine the ruby platform
  module Platform

    DEFAULT_RVM_NAME = 'mri'.freeze

    # Return Ruby engine string
    #
    # @return [String]
    #
    # @api private
    def ruby_engine
      @ruby_engine ||= (defined?(RUBY_ENGINE) && RUBY_ENGINE || 'ruby').freeze
    end

    # Return RVM name
    #
    # @return [String]
    #
    # @api private
    def rvm_name
      @rvm_name ||= begin
        engine = ruby_engine
        engine == 'ruby' ? DEFAULT_RVM_NAME : engine
      end
    end

    # Return RVM string
    #
    # @return [String]
    #
    # @api private
    def rvm
      @rvm ||= "#{rvm_name}-#{RUBY_VERSION}".freeze
    end

    # Test for being executed under JRuby
    #
    # @return [true]
    #   if running under JRuby
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    def jruby?
      ruby_engine == 'jruby'
    end

    # Test for being executed under rbx
    #
    # @return [true]
    #   if running under rbx
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    def rbx?
      ruby_engine == 'rbx'
    end

    # Test for being executed under rubies with a JIT
    #
    # @return [true]
    #   if running under JRuby or rbx
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    def jit?
      jruby? || rbx?
    end

    # Test for 1.8 mode
    #
    # @return [true]
    #   if running under 1.8.x
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    def ruby18?
      RUBY_VERSION.start_with?('1.8.')
    end

    # Test for 1.9 mode
    #
    # @return [true]
    #   if running under 1.9.x
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    def ruby19?
      RUBY_VERSION.start_with?('1.9.')
    end

    # Test for 2.0 mode
    #
    # @return [true]
    #   if running under 2.0.x
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    def ruby20?
      RUBY_VERSION.start_with?('2.0.')
    end
  end # module Platform
end # module Devtools
