module Devtools
  module Flay
    # Wrap results from running flay
    class Result
      include Concord::Public.new(:units, :report), Adamantium

      # Relative masses from flay results
      #
      # (see Unit#relative_mass)
      #
      # @return [Array<Rational>]
      #
      # @api private
      def relative_masses
        units.map(&:relative_mass)
      end

      # Result information for one unit of duplication from flay results
      class Unit
        include Anima.new(:mass, :nodes), Adamantium

        # Duplication mass relative to the number of duplicate nodes
        #
        # @return [Rational]
        #
        # @api private
        def relative_mass
          Rational(mass, nodes.size)
        end
      end
    end

    # Measure flay mass relative to size of duplicated sexps
    class Scale
      include Adamantium::Flat
      include Anima.new(:minimum_mass, :files)
      include Procto.call(:measure)

      # Measure duplication mass
      #
      # @return [Array<Rational>]
      #
      # @api private
      def measure
        units = flay.masses.map do |structural_hash, mass|
          Result::Unit.new(
            mass: mass,
            nodes: flay.hashes.fetch(structural_hash)
          )
        end

        Result.new(units, report)
      end

    private

      # Flay report summary
      #
      # flay instance is duplicated because `Flay#report`
      # mutates the instance
      #
      # @return [String]
      #
      # @api private
      def report
        StringIO.new.tap do |io|
          flay.dup.report(io)
          io.rewind
        end.read
      end

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
      memoize :flay
    end

    # Expand include and exclude file settings for flay
    class FileList
      include Procto.call, Concord.new(:includes, :excludes)

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
        ::Flay.expand_dirs_to_files(includes)
      end
    end
  end
end
