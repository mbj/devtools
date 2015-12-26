module Devtools
  module Flog
    # Representation of a list of files for flog to consume
    class FileList
      include Procto.call(:to_a), Concord.new(:directories)

      # Translate file list into an array of file paths
      #
      # @return [Array<String>]
      #
      # @api private
      def to_a
        FlogCLI.expand_dirs_to_files(directories)
      end
    end

    # Proxy interface for flog
    class Proxy
      # Default options for passing to flog
      #
      # @note passing `{ methods: true }` tells flog to exclude non-methods
      #   from results (these are represented by flog as "Foo#none")
      OPTIONS = IceNine.deep_freeze(
        methods: true
      )

      include Adamantium, Concord.new(:files)

      # Collection of totals from flog analysis
      #
      # @return [Total::Collection]
      #
      # @api private
      def totals
        Total::Collection.coerce(flogger.totals)
      end

      private

      # Flog instance with analysis results for specified files
      #
      # @return [Flog]
      #
      # @api private
      def flogger
        ::Flog.new(OPTIONS).tap { |flog| flog.flog(*files) }
      end
    end

    # Representation of a flog subject and score
    class Total
      # Decimal precision for rounding scores
      SCORE_PRECISION = 1
      FORMAT          = '%8.1f: %s'.freeze

      # Coerce a flog total pair into a Total instance
      #
      # @param subject [String]
      # @param score [Float]
      #
      # @return [Total]
      #
      # @api private
      def self.coerce(subject, score)
        new(subject, score.round(SCORE_PRECISION))
      end

      include Concord::Public.new(:subject, :score)

      # Formatted flog total string
      #
      # @return [String]
      #
      # @api private
      def to_s
        FORMAT % [score, subject]
      end

      # Collection of many total items
      class Collection
        # Method selector for sorting total objects
        COMPARATOR = :score

        # Coerce a hash of totals into a sorted total collection
        #
        # @param flog_totals [Hash{String => Float}]
        #
        # @return [Total::Collection]
        #
        # @api private
        def self.coerce(flog_totals)
          totals = flog_totals.map do |subject, score|
            Total.coerce(subject, score)
          end

          new(totals.sort_by(&COMPARATOR))
        end

        extend Forwardable

        include Adamantium, Concord.new(:totals), Enumerable

        def_delegators :totals, :each, :empty?, :size

        # Represent total collection as a string
        #
        # @return [String]
        #
        # @api private
        def to_s
          reverse_each.map(&:to_s).join("\n")
        end

        # Max score in total collection
        #
        # @return [Float]
        #
        # @api private
        def max_score
          max_by(&COMPARATOR).score
        end
        memoize :max_score
      end
    end

    # Pair of flog result totals and specified threshold
    class Result
      include Anima.new(:totals, :threshold)

      # Check if the maximum score found equals the expected threshold
      #
      # @return [Boolean]
      #
      # @api private
      def at_threshold?
        totals.max_score.equal?(threshold)
      end

      # Check if the maximum score found is below the expected threshold
      #
      # @return [Boolean]
      #
      # @api private
      def below_threshold?
        totals.max_score < threshold
      end

      # Subset collection of totals above specified threshold
      #
      # @return [Total::Collection]
      #
      # @api private
      def above
        Total::Collection.new(totals.select { |total| total.score > threshold })
      end
    end
  end
end
