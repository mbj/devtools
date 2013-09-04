# encoding: utf-8

module Devtools

  # Encapsulates a specific {Project} devtools is used for
  class Site

    attr_reader :root

    attr_reader :project

    def initialize(project)
      @project = project
      @root    = project.root
    end

    # Initialize project and load shared specs
    #
    # Expects to be called from $application_root/spec/spec_helper.rb
    #
    # @return [self]
    #
    # @api private
    def init_spec_helper
      Project::Initializer::Rspec.call(project)
      self
    end

    # Init devtools using default config
    #
    # @return [undefined]
    #
    # @api private
    def init
      Initializer.call(self)
      puts 'Run bundle install to complete the devtools installation'
      self
    end

    # Sync gemfiles
    #
    # @return [undefined]
    #
    # @api private
    def sync
      target = root.join(GEMFILE_NAME)
      FileUtils.cp(SHARED_GEMFILE_PATH, target)
      puts "Successfully synced #{target}"
      self
    end

    # Sync gemfiles and run bundle update
    #
    # @return [undefined]
    #
    # @api private
    def update
      sync
      system(BUNDLE_UPDATE)
      self
    end

  end # class Site
end # module Devtools
