# encoding: utf-8

require 'pathname'
require 'rake'
require 'timeout'
require 'yaml'

# Namespace for library
module Devtools
  extend Rake::DSL

  DEFAULT_RVM_NAME = 'mri'.freeze
  EVAL_GEMFILE     = "eval_gemfile 'Gemfile.devtools'".freeze
  REQUIRE          = "require 'devtools'".freeze
  INIT_RAKE_TASKS  = 'Devtools.init_rake_tasks'.freeze

  # Return library directory
  #
  # @return [Pathname]
  #
  # @api private
  def self.root
    @root ||= Pathname('../../').expand_path(__FILE__).freeze
  end

  # Return git branch
  #
  # @return [String]
  #
  # @api private
  def self.branch
    `git rev-parse --abbrev-ref HEAD`.strip == 'master'
  end

  # Return if current git branch is master
  #
  # @return [Boolean]
  #
  # @api private
  def self.master?
    branch == 'master'
  end

  # Notify or abort depanding on the branch
  #
  # @param [String] msg
  #
  # @return [undefined]
  #
  # @api private
  def self.notify(msg)
    if master?
      abort msg
    else
      puts msg
    end
  end

  # Return the project root directory
  #
  # Delegates to `Dir.pwd`
  #
  # @return [Pathname]
  #
  # @api private
  def self.project_root
    @project_root ||= Pathname.pwd.freeze
  end

  # Return path to shared files
  #
  # @return [Pathname]
  #
  # @api private
  def self.shared_path
    @shared_path ||= root.join('shared').freeze
  end

  # Return shared gemfile path
  #
  # @return [Pathname]
  #
  # @api private
  def self.shared_gemfile_path
    @shared_gemfile_path ||= shared_path.join('Gemfile').freeze
  end

  # Return default config path
  #
  # @return [Pathname]
  #
  # @api private
  def self.default_config_path
    @default_config_path ||= root.join('default/config').freeze
  end

  # Initialize project
  #
  # Might be called from $application_root/Rakefile (Devtools.init_rake_tasks)
  # or $application_root/spec/spec_helper.rb (Devtools.init_spec_helper), as
  # rake ci also runs rspec it can be called multiple times.
  #
  # @param [Pathname] root
  #
  # @return [self]
  #
  # @api private
  def self.init_project(root)
    if defined?(@project)
      project_root = @project.root
      if project_root != root
        raise "project root expected #{root}, but was #{project_root}"
      end
    else
      @project = Project.new(root)
    end
    self
  end

  # Initialize project and load shared specs
  #
  # Expects to be called from $application_root/spec/spec_helper.rb
  #
  # @return [self]
  #
  # @api private
  def self.init_spec_helper
    init_project(project_root)
    project.setup_rspec
    self
  end

  # Initialize project and load tasks
  #
  # Should *only* be called from your $application_root/Rakefile
  #
  # @return [self]
  #
  # @api private
  def self.init_rake_tasks
    init_project(project_root)
    import_tasks
    self
  end

  # Initialize project and load tasks
  #
  # Should *only* be called from your $application_root/Rakefile
  #
  # @deprecated Use Devtools.init_rake_tasks
  #
  # @return [self]
  #
  # @api private
  def self.init
    $stderr.puts('Devtools.init is deprecated, use Devtools.init_rake_tasks')
    init_project(project_root)
    import_tasks
  end

  # Return ruby engine string
  #
  # @return [String]
  #
  # @api private
  def self.ruby_engine
    @ruby_engine ||= (defined?(RUBY_ENGINE) && RUBY_ENGINE || 'ruby').freeze
  end

  # Return rvm name
  #
  # @return [String]
  #
  # @api private
  def self.rvm_name
    @rvm_name ||= begin
      engine = ruby_engine
      engine == 'ruby' ? DEFAULT_RVM_NAME : engine
    end
  end

  # Return rvm string
  #
  # @return [String]
  #
  # @api private
  def self.rvm
    @rvm ||= "#{rvm_name}-#{RUBY_VERSION}".freeze
  end

  # Test for being executed under jruby
  #
  # @return [true]
  #   if running under jruby
  #
  # @return [false]
  #   otherwise
  #
  # @api private
  def self.jruby?
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
  def self.rbx?
    ruby_engine == 'rbx'
  end

  # Test for being executed under rubies with a JIT
  #
  # @return [true]
  #   if running under jruby or rbx
  #
  # @return [false]
  #   otherwise
  #
  # @api private
  def self.jit?
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
  def self.ruby18?
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
  def self.ruby19?
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
  def self.ruby20?
    RUBY_VERSION.start_with?('2.0.')
  end

  # Return project
  #
  # @return [Project]
  #
  # @api private
  def self.project
    @project || raise('No active project')
  end

  # Init devtools using default config
  #
  # @return [undefined]
  #
  # @api public
  def self.init!
    config_path = project_root.join('config').tap(&:mkpath)
    cp_r default_config_path, config_path.parent

    sync!
    init_gemfile
    init_rakefile

    self
  end

  # Sync gemfiles
  #
  # @return [undefined]
  #
  # @api public
  def self.sync!
    cp root.join('shared/Gemfile'), project_root.join('Gemfile.devtools')
  end

  # Sync gemfiles and run bundle update
  #
  # @return [undefined]
  #
  # @api public
  def self.update!
    sync!
    sh 'bundle update'
  end

  # Import the rake tasks
  #
  # @return [undefined]
  #
  # @api private
  def self.import_tasks
    FileList[root.join('tasks/**/*.rake').to_s].each { |task| import(task) }
  end
  private_class_method :import_tasks

  # Initialize the Gemfile
  #
  # @return [undefined]
  #
  # @api private
  def self.init_gemfile
    gemfile = project_root.join('Gemfile')
    unless gemfile.file? && gemfile.read.include?(EVAL_GEMFILE)
      gemfile.open('a') do |file|
        file << annotate(EVAL_GEMFILE)
      end
    end
  end
  private_class_method :init_gemfile

  # Initialize the Rakefile
  #
  # @return [undefined]
  #
  # @api private
  def self.init_rakefile
    rakefile = project_root.join('Rakefile')
    unless rakefile.file? && rakefile.read.include?(INIT_RAKE_TASKS)
      rakefile.open('a') do |file|
        file << annotate([REQUIRE, INIT_RAKE_TASKS].join("\n"))
      end
    end
  end
  private_class_method :init_rakefile

  # Annotate
  #
  # @return [Boolean]
  #
  # @api private
  def self.annotate(string)
    "\n# Added by devtools\n#{string}"
  end
  private_class_method :annotate

end

require 'devtools/project'
require 'devtools/config'
