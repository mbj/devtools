# frozen_string_literal: true

module Devtools
  module Flay
    # Measure flay mass relative to size of duplicated sexps
    class Scale
      include Adamantium
      include Anima.new(:minimum_mass, :files)
      include Procto.call(:measure)

      # Measure duplication mass
      #
      # @return [Array<Rational>]
      #
      # @api private
      def measure
        flay.masses.map do |hash, mass|
          Rational(mass, flay.hashes.fetch(hash).size)
        end
      end

      # Report flay output
      #
      # @return [undefined]
      #
      # @api private
      def flay_report
        flay.report
      end

    private

      # Memoized flay instance
      #
      # @return [Flay]
      #
      # @api private
      def flay
        ::Flay.new(mass: minimum_mass).tap do |flay|
          flay.process(*files)
          flay.analyze
        end
      end
      memoize :flay, freezer: :noop
    end

    # Expand include and exclude file settings for flay
    class FileList
      include Procto.call, Concord.new(:includes, :excludes)

      GLOB = '**/*.{rb,erb}'

      # Expand includes and filter by excludes
      #
      # @return [Set<Pathname>]
      #
      # @api private
      def call
        include_set - exclude_set
      end

    private

      # Set of excluded files
      #
      # @return [Set<Pathname>]
      #
      # @api private
      def exclude_set
        excludes.flat_map(&Pathname.method(:glob))
      end

      # Set of included files
      #
      # Expanded using flay's file expander which takes into
      # account flay's plugin support
      #
      # @return [Set<Pathname>]
      #
      # @api private
      def include_set
        Set.new(flay_includes.map(&method(:Pathname)))
      end

      # Expand includes using flay
      #
      # Expanded using flay's file expander which takes into
      # account flay's plugin support
      #
      # @return [Array<String>]
      #
      # @api private
      def flay_includes
        PathExpander.new(includes.dup, GLOB).process
      end
    end
  end
end
