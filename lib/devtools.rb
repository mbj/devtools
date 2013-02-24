require 'adamantium'
require 'pathname'
require 'rake'
require 'yaml'

# Namespace for library
module Devtools
  extend Rake::DSL

  # Return library directory
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.root
    @root ||= Pathname('../../').expand_path(__FILE__).freeze
  end

  # Return shared gemfile path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.shared_gemfile_path
    @shared_gemfile_path ||= root.join('shared/Gemfile').freeze
  end

  # Return shared examples path
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.shared_examples_path
    @shared_example_path ||= root.join('shared/examples').freeze
  end

  # Initialize project and load shared specs
  #
  # Expects to be called from $application_root/spec/spec_helper.rb
  #
  # @return [self]
  #
  # @api private
  #
  def self.init_spec_helper
    init_project(root_from_caller(2))
    project.setup_rspec
    self
  end

  # Initialize project
  #
  # Might be called from $application_root/Rakefile (Devtools.init_rake_tasks) or
  # $application_root/spec/spec_helper.rb (Devtools.init_spec_helper), as rake ci also 
  # runs rspec it can be called multiple times.
  #
  # @param [Pathname] root
  #
  # @return [self]
  #
  # @api private
  #
  def self.init_project(root)
    if defined?(@project)
      if @project.root != root
        raise 'project is already initialized with different root'
      end
      return self
    end
    @project = Project.new(root)
    self
  end

  # Initialize project and load tasks
  #
  # Should *only* be called from your $application_root/Rakefile
  #
  # @return [self]
  #
  # @api private
  #
  def self.init_rake_tasks
    init_project(root_from_caller(2))
    import_tasks

    self
  end

  # Deprecated version of Devtools.init_rake_tasks
  #
  # Should *only* be called from your $application_root/Rakefile
  #
  # @return [self]
  #
  # @api private
  #
  def self.init
    $stderr.puts("Devtools.init is deprecated, use Devtools.init_rake_tasks")
    init_project(root_from_caller(2))
    import_tasks
  end

  # Return ruby engine string
  #
  # @return [String]
  #
  # @api private
  #
  def self.ruby_engine
    @ruby_engine ||= ((defined?(RUBY_ENGINE) && RUBY_ENGINE) ? RUBY_ENGINE : 'ruby').freeze
  end

  # Return rvm name
  #
  # @return [String]
  #
  # @api private
  #
  def self.rvm_name
    @rvm_name ||= begin
      engine = ruby_engine
      engine = 'mri' if engine == 'ruby'
      engine
    end.freeze
  end

  # Return rvm string
  #
  # @return [String]
  #
  # @api private
  #
  def self.rvm
    @rvm ||= "#{rvm_name}-#{RUBY_VERSION}".freeze
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
  #   if running under 2.0.x
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
    @project || raise('No active project')
  end

  # Import the rake tasks
  #
  # @return [undefined]
  #
  # @api private
  #
  def self.import_tasks
    FileList[root.join('tasks/**/*.rake').to_s].each { |task| import(task) }
  end
  private_class_method :import_tasks

  # Require shared examples
  #
  # @return [undefined]
  #
  # @api private
  #
  def self.require_shared_examples
    Dir[shared_examples_path.join('**/*.rb')].each { |file| require(file) }
  end

  # Return root from caller level 
  #
  # @param [Fixnum] level
  #
  # @return [Pathname]
  #
  # @api private
  #
  def self.root_from_caller(level)
    Pathname.new(caller(level).first.split(':').first).dirname.parent
  end
  private_class_method :root_from_caller

end

require 'devtools/project'
require 'devtools/config'
