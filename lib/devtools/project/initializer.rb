module Devtools
  class Project

    # Base class for project initializers
    class Initializer
      include AbstractType

      abstract_singleton_method :call
    end # class Initializer
  end # class Project
end # module Devtools
