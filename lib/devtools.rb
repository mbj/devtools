# frozen_string_literal: true

# Stdlib infrastructure
require 'pathname'
require 'rake'
require 'timeout'
require 'yaml'
require 'fileutils'

# Non stdlib infrastructure
require 'abstract_type'
require 'procto'
require 'anima'
require 'concord'
require 'adamantium'

# Wrapped tools
require 'flay'
require 'rspec'
require 'rspec/its'
require 'simplecov'

# Main devtools namespace population
module Devtools
  ROOT                    = Pathname.new(__FILE__).parent.parent.freeze
  PROJECT_ROOT            = Pathname.pwd.freeze
  SHARED_PATH             = ROOT.join('shared').freeze
  SHARED_SPEC_PATH        = SHARED_PATH.join('spec').freeze
  DEFAULT_CONFIG_PATH     = ROOT.join('default/config').freeze
  RAKE_FILES_GLOB         = ROOT.join('tasks/**/*.rake').to_s.freeze
  LIB_DIRECTORY_NAME      = 'lib'
  SPEC_DIRECTORY_NAME     = 'spec'
  RAKE_FILE_NAME          = 'Rakefile'
  SHARED_SPEC_PATTERN     = '{shared,support}/**/*.rb'
  UNIT_TEST_PATH_REGEXP   = %r{\bspec/unit/}
  DEFAULT_CONFIG_DIR_NAME = 'config'

  private_constant(*constants(false))

  # React to metric violation
  #
  # @param [String] msg
  #
  # @return [undefined]
  #
  # @api private
  def self.notify_metric_violation(msg)
    abort(msg)
  end

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

  # Return devtools root path
  #
  # @return [Pathname]
  #
  # @api private
  def self.root
    ROOT
  end

  # Return project
  #
  # @return [Project]
  #
  # @api private
  def self.project
    PROJECT
  end

end # module Devtools

# Devtools implementation
require 'devtools/config'
require 'devtools/project'
require 'devtools/project/initializer'
require 'devtools/project/initializer/rake'
require 'devtools/project/initializer/rspec'
require 'devtools/flay'
require 'devtools/rake/flay'

# Devtools self initialization
module Devtools
  # The project devtools is active for
  PROJECT = Project.new(PROJECT_ROOT)
end
