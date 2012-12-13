require 'rake'
require 'yaml'
require 'adamantium'

# Namespace for library
module Devtools
  extend Rake::DSL

  # Return library directory
  #
  # @return [String]
  #
  # @api private
  #
  def self.root
    @root ||= File.join(File.dirname(__FILE__), '..').freeze
  end

  # Return shared gemfile path
  # 
  # @return [String]
  #
  # @api private
  #
  def self.shared_gemfile_path
    @shared_gemfile_path ||= File.join(root, 'shared/Gemfile')
  end

  # Initialize project
  #
  # @return [self]
  #
  # @api private
  #
  def self.init
    if defined?(@project) 
      raise 'project is already initialized!'
    end

    root =File.dirname(caller(1).first.split(':').first)

    @project = Project.new(root)

    FileList["#{Devtools.root}/tasks/**/*.rake"].each { |task| import(task) }

    self
  end

  # Return ruby engine string
  #
  # @return [String]
  #
  # @api private
  #
  def self.ruby_engine
    @ruby_engine ||= (defined?(RUBY_ENGINE) && RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
  end

  # Return rvm name
  #
  # @return [String]
  #
  # @api private
  #
  def self.rvm_name
    engine = ruby_engine
    engine = 'mri' if engine == 'ruby'
    engine
  end

  # Return rvm string
  #
  # @return [String]
  #
  # @api private
  #
  def self.rvm
    @rvm ||= "#{rvm_name}-#{RUBY_VERSION}"
  end

  # Test for beeing executed under jruby
  #
  # @return [true]
  #   if running under jruby
  #
  # @return [false]
  #   otherwise
  #
  # @api private
  #
  def self.jruby?
    ruby_engine == 'jruby'
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
  #
  def self.ruby18?
    !!(RUBY_VERSION =~ /\A1\.8\./)
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
  #
  def self.ruby19?
    !!(RUBY_VERSION =~ /\A1\.9\./)
  end

  # Test for 2.0 mode
  #
  # @return [true]
  #   if running under 1.9.x
  # 
  # @return [false]
  #   otherwise
  #
  # @api private
  #
  def self.ruby20?
    !!(RUBY_VERSION =~ /\A2\.0\./)
  end

  # Return project
  #
  # @return [Project]
  #
  # @api private
  #
  def self.project
    @project || raise("#{self.class.name}#=init(path) was not called!")
  end
end

require 'devtools/project'
require 'devtools/config'
