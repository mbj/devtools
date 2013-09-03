# encoding: utf-8

require 'pathname'
require 'rake'
require 'timeout'
require 'yaml'
require 'fileutils'

require 'devtools/platform'
require 'devtools/site'
require 'devtools/site/initializer'
require 'devtools/project'
require 'devtools/config'
require 'devtools/project/initializer'
require 'devtools/project/initializer/rake'
require 'devtools/project/initializer/rspec'

# Provides access to metric tools
module Devtools

  extend Platform

  ROOT                    = Pathname.new('../../').expand_path(__FILE__).freeze
  PROJECT_ROOT            = Pathname.pwd.freeze
  SHARED_PATH             = ROOT.join('shared').freeze
  SHARED_SPEC_PATH        = SHARED_PATH.join('spec').freeze
  SHARED_GEMFILE_PATH     = SHARED_PATH.join('Gemfile').freeze
  DEFAULT_CONFIG_PATH     = ROOT.join('default/config').freeze
  RAKE_FILES_GLOB         = ROOT.join('tasks/**/*.rake').to_s.freeze
  LIB_DIRECTORY_NAME      = 'lib'.freeze
  SPEC_DIRECTORY_NAME     = 'spec'.freeze
  RB_FILE_PATTERN         = '**/*.rb'.freeze
  RAKE_FILE_NAME          = 'Rakefile'.freeze
  DEFAULT_GEMFILE_NAME    = 'Gemfile'.freeze
  GEMFILE_NAME            = 'Gemfile.devtools'.freeze
  EVAL_GEMFILE            = "eval_gemfile '#{GEMFILE_NAME}'".freeze
  BUNDLE_UPDATE           = 'bundle update'.freeze
  REQUIRE                 = "require 'devtools'".freeze
  INIT_RAKE_TASKS         = 'Devtools.init_rake_tasks'.freeze
  SHARED_SPEC_PATTERN     = '{shared,support}/**/*.rb'.freeze
  UNIT_TEST_PATH_REGEXP   = %r{\bspec/unit/}.freeze
  MASTER_BRANCH           = 'master'.freeze
  DEFAULT_CONFIG_DIR_NAME = 'config'.freeze
  ANNOTATION_WRAPPER      = "\n# Added by devtools\n%s".freeze

  # Provides devtools for a project
  SITE = Site.new(Project.new(PROJECT_ROOT))

  # Initialize project and load tasks
  #
  # Should *only* be called from your $application_root/Rakefile
  #
  # @return [self]
  #
  # @api public
  def self.init_rake_tasks
    Project::Initializer::Rake.call
    self
  end

  # Initialize project and load shared specs
  #
  # Expects to be called from $application_root/spec/spec_helper.rb
  #
  # @return [self]
  #
  # @api public
  def self.init_spec_helper
    SITE.init_spec_helper
    self
  end

  # Init devtools using default config
  #
  # @return [undefined]
  #
  # @api public
  def self.init
    SITE.init
    self
  end

  # Sync Gemfile.devtools
  #
  # @return [undefined]
  #
  # @api public
  def self.sync
    SITE.sync
  end

  # Sync Gemfile.devtools and run bundle update
  #
  # @return [undefined]
  #
  # @api public
  def self.update
    SITE.update
  end

  # Return project
  #
  # @return [Project]
  #
  # @api private
  def self.project
    SITE.project
  end

  # Require shared examples
  #
  # @param [Pathname] dir
  #   the directory containing the files to require
  #
  # @param [String] pattern
  #   the file pattern to match inside directory
  #
  # @return [self]
  #
  # @api private
  def self.require_files(dir, pattern)
    Dir[dir.join(pattern)].each { |file| require file }
    self
  end

  # Notify or abort depanding on the branch
  #
  # @param [String] msg
  #
  # @return [undefined]
  #
  # @api private
  def self.notify(msg)
    master? ? abort(msg) : puts(msg)
  end

  # Return if current git branch is master
  #
  # @return [Boolean]
  #
  # @api private
  def self.master?
    branch == MASTER_BRANCH
  end

  # Return git branch
  #
  # @return [String]
  #
  # @api private
  def self.branch
    `git rev-parse --abbrev-ref HEAD`.rstrip
  end
  private_class_method :branch

end # module Devtools
