# encoding: utf-8

require 'pathname'
require 'rake'
require 'timeout'
require 'yaml'

require 'devtools/platform'

# Namespace for library
module Devtools
  extend Rake::DSL
  extend Platform

  # Library root directory
  ROOT = Pathname('../../').expand_path(__FILE__).freeze

  # Path to shared files
  SHARED_PATH = ROOT.join('shared').freeze

  # Path to shared spec files
  SHARED_SPEC_PATH = SHARED_PATH.join('spec').freeze

  # Path to shared Gemfile
  SHARED_GEMFILE_PATH = SHARED_PATH.join('Gemfile').freeze

  # Path to default config directory
  DEFAULT_CONFIG_PATH ||= ROOT.join('default/config').freeze

  LIB_DIRECTORY_NAME   = 'lib'.freeze
  SPEC_DIRECTORY_NAME  = 'spec'.freeze
  RB_FILE_PATTERN      = '**/*.rb'.freeze
  RAKE_FILES_GLOB      = ROOT.join('tasks/**/*.rake').to_s.freeze
  RAKE_FILE_NAME       = 'Rakefile'.freeze
  DEFAULT_GEMFILE_NAME = 'Gemfile'.freeze
  GEMFILE_NAME         = 'Gemfile.devtools'.freeze
  DEFAULT_RVM_NAME     = 'mri'.freeze
  EVAL_GEMFILE         = "eval_gemfile '#{DEFAULT_GEMFILE_NAME}'".freeze
  REQUIRE              = "require 'devtools'".freeze
  INIT_RAKE_TASKS      = 'Devtools.init_rake_tasks'.freeze

  DEFAULT_CONFIG_DIRECTORY_NAME = 'config'.freeze

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
    raise 'ruby-1.8 is not supported by devtools' if ruby18?

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
    config_path = project_root.join(DEFAULT_CONFIG_DIRECTORY_NAME).tap(&:mkpath)
    cp_r(DEFAULT_CONFIG_PATH, config_path.parent)

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
    cp(SHARED_GEMFILE_PATH, project_root.join(GEMFILE_NAME))
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
    FileList[RAKE_FILES_GLOB].each { |task| import(task) }
  end
  private_class_method :import_tasks

  # Initialize the Gemfile
  #
  # @return [undefined]
  #
  # @api private
  def self.init_gemfile
    gemfile = project_root.join(DEFAULT_GEMFILE_NAME)
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
    rakefile = project_root.join(RAKE_FILE_NAME)
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
