# encoding: utf-8

module Devtools
  class Project
    class Initializer

      # Imports all devtools rake tasks into a project
      class Rake

        extend ::Rake::DSL

        def self.call
          FileList[RAKE_FILES_GLOB].each(&method(:import))
        end

      end # class Rake
    end # class Initializer
  end # class Project
end # module Devtools
