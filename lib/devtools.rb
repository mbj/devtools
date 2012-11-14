require 'yaml'
require 'adamantium'
require 'equalizer'

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
