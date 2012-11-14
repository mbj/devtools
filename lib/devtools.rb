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
  # @param [String] path
  #
  # @return [Param]
  #
  # @api private
  #
  def self.init(path)
    if defined?(@project) 
      raise 'project is already initialized!'
    end

    @project = Project.new(File.expand_path(File.join(File.dirname(path))))

    FileList["#{Devtools.root}/tasks/**/*.rake"].each { |task| import(task) }
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
