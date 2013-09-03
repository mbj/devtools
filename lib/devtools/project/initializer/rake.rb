module Devtools
  class Project
    class Initializer

      class Rake

        extend ::Rake::DSL

        def self.call
          FileList[RAKE_FILES_GLOB].each { |task| import(task) }
        end

      end # class Rake
    end # class Initializer
  end # class Project
end # module Devtools
