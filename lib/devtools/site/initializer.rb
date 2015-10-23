module Devtools
  class Site

    # Supports initializing new projects with a Rakefile
    class Initializer

      def self.call(root)
        new(root).call
      end

      attr_reader :site

      attr_reader :root

      attr_reader :config_dir

      def initialize(site)
        @site       = site
        @root       = site.root
        config_dir  = @root.join(DEFAULT_CONFIG_DIR_NAME).tap(&:mkpath)
        @config_dir = config_dir.parent
      end

      # Init devtools using default config
      #
      # @return [undefined]
      #
      # @api public
      def call
        FileUtils.cp_r(DEFAULT_CONFIG_PATH, config_dir)

        site.sync
        init_rakefile

        self
      end

      private

      # Initialize the Rakefile
      #
      # @return [undefined]
      #
      # @api private
      def init_rakefile
        rakefile = root.join(RAKE_FILE_NAME)
        return if rakefile.file? && rakefile.read.include?(INIT_RAKE_TASKS)
        rakefile.open('a') do |file|
          file << ANNOTATION_WRAPPER % [REQUIRE, INIT_RAKE_TASKS].join("\n")
        end
      end

    end # class Initializer
  end # class Site
end # module Devtools
