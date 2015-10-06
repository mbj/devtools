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
  end
end
