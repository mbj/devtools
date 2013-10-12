# encoding: utf-8

module Develry
  class Project
    class Initializer

      # Imports all develry rake tasks into a project
      class Rake

        extend ::Rake::DSL

        def self.call
          FileList[RAKE_FILES_GLOB].each { |task| import(task) }
        end

      end # class Rake
    end # class Initializer
  end # class Project
end # module Develry
